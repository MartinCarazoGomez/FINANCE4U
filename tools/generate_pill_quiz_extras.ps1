$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$pyPath = Join-Path $root 'tools\generate_pill_quiz_extras.py'
$outPath = Join-Path $root 'lib\data\pill_quiz_extras.dart'

function Escape-Dart([string]$s) {
    return $s -replace "\\", "\\\\" -replace "'", "\'"
}

$py = Get-Content -Path $pyPath -Raw -Encoding UTF8
$pillMatches = [regex]::Matches($py, '(?ms)^    "([^"]+)": \[\s*(.*?)\s*\],(?=\s*(?:    "|}))')
if ($pillMatches.Count -ne 54) {
    throw "Expected 54 pills, found $($pillMatches.Count)"
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('/// Extra PillQuiz questions (7 per pill) for FINANCE4U EduPills.')
[void]$sb.AppendLine('/// Convert to [PillQuiz] in content_screen.dart.')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('class PillQuizData {')
[void]$sb.AppendLine('  final String question;')
[void]$sb.AppendLine('  final List<String> options;')
[void]$sb.AppendLine('  final int correctIndex;')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('  const PillQuizData({')
[void]$sb.AppendLine('    required this.question,')
[void]$sb.AppendLine('    required this.options,')
[void]$sb.AppendLine('    required this.correctIndex,')
[void]$sb.AppendLine('  });')
[void]$sb.AppendLine('}')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('/// Seven additional quiz questions per pill title (54 pills × 7 = 378).')
[void]$sb.AppendLine('const pillQuizExtras = <String, List<PillQuizData>>{')

$totalQ = 0
foreach ($pm in $pillMatches) {
    $title = $pm.Groups[1].Value
    $body = $pm.Groups[2].Value
    [void]$sb.AppendLine("  '$(Escape-Dart $title)': [")
    $qMatches = [regex]::Matches($body, '(?ms)\("([^"]*)",\s*\[(.*?)\],\s*(\d+)\)')
    if ($qMatches.Count -ne 7) {
        throw "Pill '$title': expected 7 questions, found $($qMatches.Count)"
    }
    foreach ($qm in $qMatches) {
        $question = Escape-Dart $qm.Groups[1].Value
        $optsRaw = $qm.Groups[2].Value
        $correct = $qm.Groups[3].Value
        $optMatches = [regex]::Matches($optsRaw, '"((?:\\.|[^"\\])*)"')
        $opts = @()
        foreach ($om in $optMatches) {
            $opts += $om.Groups[1].Value
        }
        if ($opts.Count -ne 4) {
            throw "Pill '$title': question '$question' has $($opts.Count) options"
        }
        $optsDart = ($opts | ForEach-Object { "'$(Escape-Dart $_)'" }) -join ', '
        [void]$sb.AppendLine('    PillQuizData(')
        [void]$sb.AppendLine("      question: '$question',")
        [void]$sb.AppendLine("      options: [$optsDart],")
        [void]$sb.AppendLine("      correctIndex: $correct,")
        [void]$sb.AppendLine('    ),')
        $totalQ++
    }
    [void]$sb.AppendLine('  ],')
}

[void]$sb.AppendLine('};')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('/// Returns extra quiz questions for a pill title, or empty list if unknown.')
[void]$sb.AppendLine('List<PillQuizData> extraQuizzesFor(String pillTitle) {')
[void]$sb.AppendLine('  return pillQuizExtras[pillTitle] ?? const [];')
[void]$sb.AppendLine('}')
[void]$sb.AppendLine('')

[System.IO.File]::WriteAllText($outPath, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
$lineCount = (Get-Content $outPath).Count
Write-Host "Wrote $outPath ($lineCount lines, $totalQ questions, $($pillMatches.Count) pills)"
