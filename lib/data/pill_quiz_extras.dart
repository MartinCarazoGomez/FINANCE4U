import 'pill_quiz_data.dart';

/// Seven additional quiz questions per pill title (54 pills x 7 = 378).
const pillQuizExtras = <String, List<PillQuizData>>{
  'Regla 50/30/20': [
    PillQuizData(
      question: '¿Qué porcentaje de ingresos destina la regla a deseos y ocio?',
      options: ['10%', '20%', '30%', '50%'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: 'Si cobras 1.600€ netos al mes, ¿cuánto destinarías a necesidades básicas?',
      options: ['480€', '640€', '800€', '960€'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Qué hacer si tus gastos fijos superan el 50% de ingresos?',
      options: ['Ignorarlo', 'Revisar y reducir gastos fijos', 'Pedir más crédito', 'Dejar de ahorrar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error compromete la regla 50/30/20?',
      options: ['Automatizar el ahorro', 'Usar el ahorro para gastos no urgentes', 'Revisar el presupuesto', 'Separar cuentas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Con ingresos variables, ¿sobre qué base conviene aplicar la regla?',
      options: ['El mejor mes del año', 'El ingreso medio reciente', 'Solo la nómina base', 'Los ingresos brutos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cuál de estos NO es un bloque de la regla 50/30/20?',
      options: ['Necesidades', 'Deseos', 'Ahorro e inversión', 'Impuestos directos'],
      correctIndex: 3,
    ),
    PillQuizData(
      question: '¿Por qué automatizar el 20% de ahorro?',
      options: ['Evita pagar IVA', 'Crea el hábito antes de gastar', 'Sube el salario', 'Elimina deudas'],
      correctIndex: 1,
    ),
  ],
  'Fondo de emergencia': [
    PillQuizData(
      question: '¿Qué gastos deben cubrir los meses del fondo de emergencia?',
      options: ['Vacaciones y ocio', 'Gastos básicos esenciales', 'Inversiones en bolsa', 'Compras de lujo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué no conviene invertir el fondo de emergencia en bolsa?',
      options: ['No genera rentabilidad', 'Riesgo y falta de liquidez inmediata', 'Es ilegal', 'Paga más impuestos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Con qué frecuencia revisar el fondo de emergencia?',
      options: ['Nunca', 'Al menos una vez al año', 'Cada década', 'Solo al jubilarte'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Para qué NO deberías usar el fondo de emergencia?',
      options: ['Avería del coche', 'Vacaciones planificadas', 'Pérdida de empleo', 'Reparación urgente'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si tus gastos básicos son 900€/mes, ¿cuánto mínimo recomiendan (3 meses)?',
      options: ['900€', '1.800€', '2.700€', '9.000€'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Por qué evitar guardar el fondo en efectivo en casa?',
      options: ['No genera intereses', 'Riesgo de robo o incendio', 'El banco lo prohíbe', 'Pierdes la nómina'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si solo puedes ahorrar 20€ al mes, ¿qué hacer?',
      options: ['Esperar a ganar más', 'Empezar igualmente poco a poco', 'Pedir un préstamo', 'No crear fondo'],
      correctIndex: 1,
    ),
  ],
  'Ahorro automático': [
    PillQuizData(
      question: '¿Qué bancos españoles permiten transferencias automáticas?',
      options: ['Ninguno', 'La mayoría de bancos tradicionales y online', 'Solo el Banco de España', 'Solo cajas rurales'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué ahorrar el día después de cobrar?',
      options: ['Porque el banco lo exige', 'Antes de que el dinero se gaste', 'Para pagar menos IRPF', 'Para evitar el IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué estrategia complementa bien el ahorro automático?',
      options: ['Gastar primero y ahorrar lo que sobre', 'Cuenta de ahorro separada del día a día', 'Usar solo efectivo', 'Cancelar seguros'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué hacer si al principio no puedes ahorrar mucho?',
      options: ['No automatizar nada', 'Empezar con una cantidad pequeña y subirla', 'Pedir crédito', 'Esperar a fin de año'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué ventaja tienen las cuentas de ahorro online para automatizar?',
      options: ['Sin comisiones y rentabilidad', 'Garantizan doble salario', 'Evitan impuestos', 'Sin límites legales'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Qué problema evita el ahorro automático?',
      options: ['La inflación directamente', 'Depender solo de la fuerza de voluntad', 'Pagar hipoteca', 'Cotizar a la Seguridad Social'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué NO es una buena práctica con el ahorro automático?',
      options: ['Programar transferencia periódica', 'Ir subiendo la cantidad gradualmente', 'Usar la cuenta de ahorro para caprichos', 'Revisar el progreso'],
      correctIndex: 2,
    ),
  ],
  'Evita gastos hormiga': [
    PillQuizData(
      question: '¿Qué incluyen típicamente los gastos hormiga?',
      options: ['Hipoteca y alquiler', 'Cafés, snacks y suscripciones pequeñas', 'Seguro del coche', 'IRPF anual'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué herramienta ayuda a detectar gastos hormiga?',
      options: ['Solo la memoria', 'Apps o extractos bancarios categorizados', 'Redes sociales', 'Lotería'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si gastas 2€ diarios en snacks laborables (~22 días), ¿cuánto al mes?',
      options: ['22€', '44€', '66€', '220€'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué actitud frena los gastos hormiga?',
      options: ['Comprar más en rebajas', 'Conciencia y registro de pequeños gastos', 'Usar más tarjetas', 'Pedir préstamos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error común impide reducir gastos hormiga?',
      options: ['Revisar movimientos bancarios', 'Pensar que \'no importan\' por ser pequeños', 'Llevar café de casa', 'Anotar gastos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué suscripción olvidada suele ser gasto hormiga?',
      options: ['Hipoteca', 'App o streaming no usado', 'Seguridad Social', 'IBI'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cuál es el beneficio de reducir gastos hormiga?',
      options: ['Más capacidad de ahorro real', 'Menos impuestos automáticos', 'Mejor historial hipotecario directo', 'Subida de nómina'],
      correctIndex: 0,
    ),
  ],
  'Reto de 30 días': [
    PillQuizData(
      question: '¿Qué variante del reto incrementa el ahorro cada día?',
      options: ['Ahorrar lo mismo siempre', '1€ día 1, 2€ día 2, etc.', 'Gastar menos solo el día 30', 'Invertir en bolsa'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué herramienta bancaria ayuda a seguir el reto?',
      options: ['Tarjeta revolving', 'Metas o subcuentas de ahorro', 'Préstamo personal', 'Cuenta de crédito'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error arruina el reto de 30 días?',
      options: ['Registrar el progreso', 'Perder la constancia a mitad', 'Compartir el reto', 'Empezar con 1€'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si ahorras 5€ fijos cada día durante 30 días, ¿cuánto acumulas?',
      options: ['30€', '75€', '150€', '465€'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Por qué transferir el ahorro al terminar el reto?',
      options: ['Para pagar impuestos', 'Evitar gastarlo impulsivamente', 'Por ley bancaria', 'Para invertir en FOREX'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué beneficio psicológico da el reto?',
      options: ['Ver resultados rápidos y crear hábito', 'Eliminar deudas al instante', 'Evitar cotizar', 'Subir el Euríbor'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Con quién puede ser útil compartir el reto?',
      options: ['Solo con el banco', 'Amigos o familia para motivación', 'Con inversores FOREX', 'Con Hacienda'],
      correctIndex: 1,
    ),
  ],
  '¿Qué son los impuestos?': [
    PillQuizData(
      question: '¿Qué impuesto grava la propiedad de una vivienda en España?',
      options: ['IVA', 'IBI', 'IRPF', 'IVA superreducido'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué significa que el IRPF es progresivo?',
      options: ['Todos pagan lo mismo', 'A más ingresos, tipos más altos en tramos', 'Solo pagan empresas', 'Los tipos bajan con el salario'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué servicio público NO financia directamente la fiscalidad general?',
      options: ['Sanidad', 'Educación', 'Salario privado de empresas', 'Pensiones'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Qué impuesto pagan las empresas sobre beneficios?',
      options: ['IRPF', 'Impuesto de Sociedades', 'IVA', 'IBI'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué impuestos especiales existen en España?',
      options: ['Solo IRPF', 'Gasolina, alcohol y tabaco', 'Solo IVA', 'Ninguno'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué declarar todos los ingresos?',
      options: ['Es opcional', 'Obligación legal y evita sanciones', 'Solo si eres autónomo', 'Para cobrar paro'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué ventaja tiene entender los impuestos?',
      options: ['Evitar pagarlos', 'Planificar mejor las finanzas personales', 'No cotizar', 'Eliminar el IVA'],
      correctIndex: 1,
    ),
  ],
  'IRPF: El impuesto principal': [
    PillQuizData(
      question: '¿Qué es la base imponible del IRPF?',
      options: ['Solo el salario neto', 'Ingresos menos deducciones permitidas', 'El IVA pagado', 'La hipoteca'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué deducción puede reducir tu IRPF?',
      options: ['Compras de ropa', 'Aportaciones a plan de pensiones', 'Lotería', 'Vacaciones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué ocurre si las retenciones superan lo debido?',
      options: ['Pierdes el dinero', 'Hacienda puede devolverte', 'Sube el IVA', 'No pasa nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué ingresos deben incluirse en la declaración?',
      options: ['Solo nómina', 'Salario, alquileres, freelance, etc.', 'Solo efectivo', 'Solo pensiones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Para qué sirve un gestor en IRPF complejo?',
      options: ['Evitar pagar impuestos', 'Optimizar y cumplir correctamente', 'Eliminar retenciones', 'No declarar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué tramo de IRPF aplica a ingresos muy altos (ej. >300.000€)?',
      options: ['19%', '24%', '47%', '0%'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Qué documentos conviene guardar para deducciones?',
      options: ['Solo nóminas', 'Justificantes de gastos deducibles', 'Tickets de ocio', 'Recibos de lotería'],
      correctIndex: 1,
    ),
  ],
  'Seguridad Social': [
    PillQuizData(
      question: '¿Qué prestación cubre baja por maternidad/paternidad?',
      options: ['Solo IRPF', 'Seguridad Social', 'IVA', 'IBI'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Quién paga la mayor parte de cotizaciones en un contrato?',
      options: ['El trabajador solo', 'Principalmente la empresa', 'El cliente', 'Hacienda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué documento revisar para verificar años cotizados?',
      options: ['DNI', 'Informe de vida laboral', 'Pasaporte', 'Carnet de conducir'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué factor influye en el cálculo de la pensión?',
      options: ['Color del coche', 'Años cotizados y base reguladora', 'Número de hijos solo', 'Tipo de vivienda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cómo cotizan los autónomos?',
      options: ['No cotizan', 'Cuotas mensuales según ingresos/base', 'Solo en verano', 'Una vez al año'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué cubre la asistencia sanitaria pública?',
      options: ['Solo dentistas privados', 'Atención médica básica', 'Vacaciones', 'Seguro de hogar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué complementar con plan de pensiones privado?',
      options: ['Es obligatorio', 'Complementar pensión pública futura', 'Evitar IVA', 'No pagar IRPF'],
      correctIndex: 1,
    ),
  ],
  'IVA: El impuesto invisible': [
    PillQuizData(
      question: '¿Qué tipo de IVA aplica al transporte público en España?',
      options: ['4%', '10% reducido', '21% general', '0%'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si un producto cuesta 100€ sin IVA al 21%, ¿precio final?',
      options: ['110€', '121€', '100€', '131€'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Quién puede deducir IVA de sus compras profesionales?',
      options: ['Cualquier particular', 'Autónomos y empresas', 'Solo jubilados', 'Menores de edad'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué estrategia reduce impacto del IVA en consumo?',
      options: ['Comprar solo productos al 21%', 'Priorizar productos con IVA reducido', 'No comprar nunca', 'Pagar en efectivo siempre'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿El precio en tienda ya incluye IVA?',
      options: ['No, se suma al pagar', 'Sí, en la mayoría de casos', 'Solo online', 'Solo en restauración'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué IVA llevan la ropa y tecnología?',
      options: ['4%', '10%', '21% general', '0%'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Por qué guardar facturas importantes?',
      options: ['Por moda', 'Para deducciones o reclamaciones', 'Evitar IRPF', 'Cobrar paro'],
      correctIndex: 1,
    ),
  ],
  'Ejemplo completo: ¿Cuánto se lleva el Estado?': [
    PillQuizData(
      question: 'En el ejemplo de María, ¿qué impuesto se descuenta mensualmente de nómina además de IRPF?',
      options: ['IBI', 'Cotizaciones a Seguridad Social', 'ITP', 'Impuesto de circulación'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué porcentaje aproximado de impuestos sobre bruto muestra el ejemplo?',
      options: ['10%', '25%', '40% aprox.', '90%'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Qué impuesto anual paga quien tiene vivienda (IBI)?',
      options: ['Sobre compra', 'Sobre propiedad del inmueble', 'Sobre salario', 'Sobre nómina'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué financia el IRPF recaudado?',
      options: ['Solo empresas privadas', 'Gastos públicos del Estado', 'Vacaciones de funcionarios', 'Solo defensa'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué el IVA es \'invisible\' para el consumidor?',
      options: ['No existe', 'Ya va incluido en el precio final', 'Solo lo pagan ricos', 'Es voluntario'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué optimización fiscal menciona el ejemplo?',
      options: ['No pagar IVA', 'Planes de pensiones y deducciones', 'Esconder ingresos', 'Solo efectivo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué representa el salario neto real en el ejemplo?',
      options: ['Bruto menos impuestos y cotizaciones', 'Solo bruto', 'Solo IVA', 'Beneficio empresarial'],
      correctIndex: 0,
    ),
  ],
  '¿Qué es invertir?': [
    PillQuizData(
      question: '¿Qué riesgo tiene dejar ahorros sin remunerar?',
      options: ['Ganar demasiado', 'Pérdida de poder adquisitivo por inflación', 'Pagar más IVA', 'Subir IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué hacer antes de invertir?',
      options: ['Pedir préstamo', 'Definir objetivo y horizonte', 'Gastar todo', 'Solo seguir modas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué NO deberías invertir?',
      options: ['Dinero para emergencias a corto plazo', 'Excedente a largo plazo', 'Ahorro para jubilación', 'Capital sobrante'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Qué tributan las ganancias de fondos y acciones en España?',
      options: ['IVA', 'IRPF', 'IBI', 'Ninguno'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error evitar al invertir?',
      options: ['Diversificar', 'Invertir sin entender el producto', 'Informarse', 'Comparar comisiones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué producto combina ahorro jubilación y ventaja fiscal?',
      options: ['Cuenta corriente', 'Plan de pensiones', 'Préstamo personal', 'Tarjeta revolving'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Invertir es lo mismo que apostar?',
      options: ['Sí, idéntico', 'No, es estrategia a medio/largo plazo', 'Solo en cripto', 'Solo en vivienda'],
      correctIndex: 1,
    ),
  ],
  'Diversificación': [
    PillQuizData(
      question: '¿Qué problema tiene concentrar todo en vivienda o depósitos?',
      options: ['Menos impuestos', 'Mayor riesgo si ese activo cae', 'Más liquidez', 'Mejor diversificación'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Con qué frecuencia revisar la cartera diversificada?',
      options: ['Cada hora', 'Al menos una vez al año', 'Nunca', 'Solo en crisis'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué sectores ayudan a diversificar?',
      options: ['Uno solo siempre', 'Renta fija, variable, depósitos, etc.', 'Solo cripto', 'Solo efectivo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error de diversificación es común en España?',
      options: ['Usar fondos', 'Concentrar todo en vivienda', 'Tener depósitos', 'Leer folletos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si tienes 10.000€, ¿qué reparto ilustra diversificación?',
      options: ['Todo en una acción', 'Fondos fijos + variables + depósito', 'Todo efectivo', 'Solo deuda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿La diversificación elimina todo riesgo?',
      options: ['Sí, totalmente', 'No, pero lo reduce', 'Solo en depósitos', 'Solo en bonos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué no invertir solo en lo cómodo?',
      options: ['Porque es ilegal', 'Aumenta concentración de riesgo', 'Paga más IVA', 'Sube IRPF'],
      correctIndex: 1,
    ),
  ],
  'Riesgo y rentabilidad': [
    PillQuizData(
      question: '¿Qué es el riesgo de liquidez?',
      options: ['Que suba el Euríbor', 'No poder vender cuando necesitas sin pérdida', 'Robo bancario', 'Solo en vivienda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Hasta cuánto están garantizados depósitos en España?',
      options: ['10.000€', '50.000€', '100.000€', 'Sin límite'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Qué perfil puede asumir más riesgo?',
      options: ['Joven con horizonte largo', 'Prejubilado sin ahorro', 'Quien necesita dinero en 1 año', 'Sin fondo emergencia'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Qué normativa clasifica riesgo 1-7 en España?',
      options: ['MiFID europea', 'Ley de loterías', 'Código civil', 'IBI'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Qué producto es riesgo medio-bajo típico?',
      options: ['Criptomonedas', 'Fondos de renta fija', 'Acciones emergentes', 'Derivados apalancados'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué es riesgo de inflación?',
      options: ['Robo', 'Pérdida de poder adquisitivo', 'Impago bancario', 'Solo en hipotecas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué evalúa el test de perfil inversor?',
      options: ['Color favorito', 'Edad, experiencia, objetivos y tolerancia', 'Número de hijos solo', 'Marca del móvil'],
      correctIndex: 1,
    ),
  ],
  'Invierte a largo plazo': [
    PillQuizData(
      question: '¿Qué ventaja da el interés compuesto a largo plazo?',
      options: ['Pagar menos IVA', 'Reinvertir ganancias que generan más ganancias', 'Eliminar comisiones', 'Evitar IRPF siempre'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué es dollar-cost averaging?',
      options: ['Vender todo en pánico', 'Invertir cantidad fija periódicamente', 'Solo comprar en máximos', 'Apostar en FOREX'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué no vender en pánico cuando baja el mercado?',
      options: ['Porque siempre sube mañana', 'El tiempo permite recuperación histórica', 'Es ilegal vender', 'El banco lo prohíbe'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué horizonte para fondos de renta variable global?',
      options: ['1 mes', '10+ años típicamente', 'Solo 1 día', 'Solo 1 semana'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error con dinero a corto plazo?',
      options: ['Fondo emergencia líquido', 'Invertirlo en productos volátiles de largo plazo', 'Depósito', 'Cuenta remunerada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Con qué frecuencia revisar inversiones sin obsesionarse?',
      options: ['Cada minuto', 'Una vez al mes puede bastar', 'Nunca mirar', 'Solo en Navidad'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué aliado es clave según la lección?',
      options: ['La impulsividad', 'El tiempo', 'El apalancamiento extremo', 'Comprar rumores'],
      correctIndex: 1,
    ),
  ],
  'Fondos de inversión': [
    PillQuizData(
      question: '¿Qué son las participaciones de un fondo?',
      options: ['Acciones de una empresa', 'Cuotas proporcionales del patrimonio del fondo', 'Bonos del Estado', 'Depósitos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué comisión descuenta anualmente del patrimonio?',
      options: ['Solo suscripción', 'Comisión de gestión', 'IRPF mensual', 'IBI'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué ventaja fiscal tienen traspasos entre fondos en España?',
      options: ['Siempre libres de impuesto al traspasar', 'No tributas hasta vender (traspaso diferido)', 'Exentos de IRPF para siempre', 'Sin comisiones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué fondo replica un índice con bajas comisiones?',
      options: ['Gestión activa cara', 'ETF o fondo indexado pasivo', 'Fondo temático único', 'Producto estructurado'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué leer antes de invertir en un fondo?',
      options: ['Solo publicidad', 'Folleto informativo obligatorio', 'Comentarios anónimos', 'Nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué no elegir solo por rentabilidad pasada?',
      options: ['Garantiza futuro', 'No garantiza rentabilidad futura', 'Es ilegal mirar', 'Sube comisiones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Inversión mínima típica en muchos fondos españoles?',
      options: ['Desde 100€ aprox.', 'Solo 1 millón €', 'Solo 0€', '50.000€ mínimo'],
      correctIndex: 0,
    ),
  ],
  'Cómo crean dinero los bancos': [
    PillQuizData(
      question: '¿Qué tipo de dinero crean principalmente los bancos al prestar?',
      options: ['Solo billetes', 'Depósitos bancarios (dinero scriptural)', 'Monedas de oro', 'Criptomonedas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué es la reserva fraccionaria?',
      options: ['Guardar todo en efectivo', 'Mantener parte de depósitos y prestar el resto', 'No prestar nunca', 'Imprimir billetes'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué hace el BCE con tipos de interés?',
      options: ['Fija salarios', 'Influye en crédito e inflación', 'Cobra IVA', 'Emite DNI'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué ocurre si muchos retiran depósitos a la vez?',
      options: ['Banco tiene todo en efectivo', 'Solo fracción disponible; existen garantías', 'Sube IRPF', 'Baja Euríbor automático'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Crédito barato y abundante suele...',
      options: ['Reducir siempre precios', 'Impulsar economía pero puede inflar', 'Eliminar IVA', 'Quitar pensiones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Tu deuda hipotecaria pagada implica...?',
      options: ['Más dinero circulante', 'Ese dinero deja de circular en el sistema', 'Sube Euríbor', 'Baja IBI'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué mito es falso sobre bancos?',
      options: ['Crean depósitos al prestar', 'Solo prestan lo ya depositado por otros', 'BCE regula', 'Hay garantía depósitos'],
      correctIndex: 1,
    ),
  ],
  'Planes de pensiones': [
    PillQuizData(
      question: '¿Cuánto pueden desgravar mayores de 50 años (límite ampliado)?',
      options: ['500€', '1.500€', 'Hasta 2.000€', 'Sin límite'],
      correctIndex: 2,
    ),
    PillQuizData(
      question: '¿Qué ocurre con beneficios dentro del plan?',
      options: ['Tributan cada año', 'No tributan hasta rescate', 'Pagan IVA', 'Se pierden'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué plan ofrece la empresa al trabajador?',
      options: ['Plan individual solo', 'Plan de empleo', 'Plan de lotería', 'Ninguno legal'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué circunstancia permite rescate anticipado?',
      options: ['Comprar móvil', 'Desempleo larga duración (según normativa)', 'Vacaciones', 'Capricho'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error con comisiones altas?',
      options: ['Mejoran rentabilidad neta', 'Reducen rentabilidad neta', 'Son gratis', 'Evitan IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cómo tributa el rescate del plan?',
      options: ['Como donación', 'Como rendimientos del trabajo (IRPF)', 'Exento siempre', 'Solo IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué no usar plan como fondo emergencia?',
      options: ['Liquidez inmediata', 'Pierdes ventajas fiscales y liquidez', 'Paga más IVA', 'Es obligatorio'],
      correctIndex: 1,
    ),
  ],
  'FOREX y cobertura cambiaria': [
    PillQuizData(
      question: '¿Qué par es base/cotizada en EUR/USD?',
      options: ['USD/EUR', 'Euro frente a dólar', 'Solo oro', 'IBEX/Euríbor'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué mueve tipos de cambio?',
      options: ['Solo turismo', 'Tipos de interés, inflación, riesgo geopolítico', 'Solo IRPF', 'Color del billete'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si EUR/USD sube, ¿qué pasa con acciones USA en euros?',
      options: ['Valen más en euros', 'Valen menos en euros si precio USD igual', 'No cambia nunca', 'Sube IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué riesgo del FOREX retail?',
      options: ['Apalancamiento y pérdidas rápidas', 'Sin riesgo', 'Solo ganancias', 'Garantía estatal'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Qué es una opción de divisas?',
      options: ['Obligación de cambiar', 'Derecho (no obligación) a tipo acordado', 'Préstamo hipotecario', 'Plan pensiones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué hacer si viajas y compras fuera UE?',
      options: ['No comparar', 'Comparar tipos (banco vs fintech)', 'Solo efectivo caro', 'FOREX apalancado'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿FOREX especulativo vs cobertura?',
      options: ['Igual de riesgoso siempre', 'Cobertura protege operaciones reales', 'Cobertura es apuesta', 'Solo empresas especulan'],
      correctIndex: 1,
    ),
  ],
  'Simula una inversión': [
    PillQuizData(
      question: '¿Qué activo es recomendable para principiantes en simulación?',
      options: ['Derivados apalancados', 'Acciones IBEX o ETF conocido', 'Solo cripto apalancada', 'Ninguno'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué registrar cada semana en la simulación?',
      options: ['Solo el clima', 'Precio, variación y noticias relevantes', 'Nada', 'Solo redes sociales'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué es análisis técnico básico?',
      options: ['Solo rumores', 'Observar tendencias de precio', 'Ignorar datos', 'Solo fundamental'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error evita la simulación?',
      options: ['Aprender disciplina', 'Vender en pánico sin experiencia previa', 'Investigar', 'Documentar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Tratar la simulación como dinero real implica...?',
      options: ['Hacer trampas', 'Decisiones serias y honestas', 'No anotar nada', 'Solo ganar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué lección da la volatilidad semanal?',
      options: ['Precios estables siempre', 'Suben y bajan con frecuencia', 'Solo suben', 'Sin noticias'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Después del mes, ¿qué reflexionar?',
      options: ['Solo suerte', 'Si fuiste racional o emocional', 'Nada', 'Culpar al mercado'],
      correctIndex: 1,
    ),
  ],
  '¿Qué es un presupuesto?': [
    PillQuizData(
      question: '¿Qué incluir en ingresos del presupuesto?',
      options: ['Solo nómina si hay más fuentes', 'Nómina, ayudas, alquileres, etc.', 'Solo efectivo', 'Solo bonus'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué gasto olvidan a menudo las familias?',
      options: ['Alquiler mensual', 'Gastos anuales o trimestrales', 'Comida básica', 'Transporte fijo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué herramienta categoriza gastos en bancos españoles?',
      options: ['Solo papel', 'App del banco o apps como Fintonic', 'Solo lotería', 'Ninguna'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué involucrar a la familia?',
      options: ['Para gastar más', 'Conciencia y colaboración en ahorro', 'Evitar IRPF', 'Obligación legal'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué es flujo de caja negativo?',
      options: ['Gastas más de lo que ingresas', 'Ahorras mucho', 'Sin deudas', 'Sin gastos'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Qué categoría es gasto fijo?',
      options: ['Restaurante ocasional', 'Alquiler o hipoteca', 'Ropa impulsiva', 'Capricho'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Beneficio de control mensual?',
      options: ['Sorpresas a final de mes', 'Anticipar y planificar', 'Más deudas', 'Menos transparencia'],
      correctIndex: 1,
    ),
  ],
  'Registra tus gastos': [
    PillQuizData(
      question: '¿Qué método ayuda a no olvidar gastos?',
      options: ['Registrar semanalmente o diariamente', 'Solo memoria', 'Una vez al año', 'Nunca'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Qué ventaja de categorizar gastos?',
      options: ['Gastar más', 'Ver patrones y negociar tarifas', 'Evitar IRPF', 'Subir nómina'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error al registrar?',
      options: ['Ser honesto', 'No apuntar compras capricho', 'Usar app', 'Revisar extractos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cuánto pueden sumar gastos hormiga al año?',
      options: ['Siempre menos de 10€', 'Más de 500€ en muchos casos', 'Cero', 'Solo millonarios'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué guardar además de tickets?',
      options: ['Solo fotos', 'Movimientos bancarios', 'Nada', 'Solo efectivo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué negociar tarifas tras registrar?',
      options: ['No sirve', 'Detectas gastos altos recurrentes', 'Sube IRPF', 'Es ilegal'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Hábito comparable a registrar gastos?',
      options: ['Como lavarse los dientes: constancia', 'Solo una vez', 'Nunca', 'Solo en crisis'],
      correctIndex: 0,
    ),
  ],
  'Prioriza necesidades': [
    PillQuizData(
      question: '¿Qué es una necesidad básica?',
      options: ['Último móvil', 'Vivienda y alimentación', 'Viaje de lujo', 'Ropa de marca'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué error al justificar deseos?',
      options: ['\'Necesito el último móvil para trabajar\' sin ser cierto', 'Priorizar alquiler', 'Pagar suministros', 'Salud básica'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: 'En crisis económica, ¿qué priorizar?',
      options: ['Deseos primero', 'Necesidades para estabilidad', 'Solo ocio', 'Deudas nuevas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué técnica ayuda a priorizar?',
      options: ['Lista necesidades vs deseos', 'Comprar primero deseos', 'Ignorar lista', 'Solo tarjeta'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Beneficio de cubrir necesidades primero?',
      options: ['Más estrés', 'Tranquilidad y libertad para deseos después', 'Más deuda', 'Menos ahorro siempre'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Transporte al trabajo es...?',
      options: ['Siempre deseo', 'Generalmente necesidad', 'Siempre lujo', 'Impuesto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si recortas, ¿por dónde empezar?',
      options: ['Alquiler', 'Deseos y gastos discrecionales', 'Medicamentos', 'Comida básica'],
      correctIndex: 1,
    ),
  ],
  'Ajusta tu presupuesto': [
    PillQuizData(
      question: '¿Qué evento exige ajustar presupuesto?',
      options: ['Nada', 'Paga extra, devolución Hacienda, imprevistos', 'Solo lunes', 'Cambio de estación irrelevante'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Si gastaste de más, ¿qué hacer?',
      options: ['Repetir igual', 'Analizar causa y corregir mes siguiente', 'Ignorar', 'Pedir crédito siempre'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué son gastos de Navidad o vuelta al cole?',
      options: ['Fijos mensuales', 'Estacionales previsibles', 'Ingresos', 'Impuestos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Herramienta para ver tendencias?',
      options: ['Solo calculadora', 'Gráficos en app bancaria', 'Nada', 'Lotería'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué mantener al ajustar?',
      options: ['Olvidar objetivos largo plazo', 'Vista en metas a largo plazo', 'Gastar todo', 'Sin revisión'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Reunión familiar mensual sirve para...?',
      options: ['Gastar más', 'Revisar presupuesto conjunto', 'Evitar ahorro', 'Solo ocio'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Flexibilidad en presupuesto implica...?',
      options: ['Abandonar metas', 'Adaptarse sin perder objetivos', 'No registrar', 'Más deuda siempre'],
      correctIndex: 1,
    ),
  ],
  'Crea tu presupuesto': [
    PillQuizData(
      question: '¿Qué paso tras clasificar necesidades/deseos?',
      options: ['Ignorar', 'Buscar gasto reducible y fijar ahorro', 'Pedir préstamo', 'Solo invertir'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué compartir presupuesto con alguien de confianza?',
      options: ['Presumir', 'Feedback y motivación', 'Evitar IRPF', 'Obligación'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Objetivo de ahorro mensual aunque sea pequeño?',
      options: ['No necesario', 'Sí, crear hábito', 'Solo millonarios', 'Solo jubilados'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error de ser irrealista?',
      options: ['Subestimar gastos o sobreestimar ingresos', 'Usar hoja cálculo', 'Revisar', 'Involucrar familia'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Duración mínima para anotar ingresos/gastos inicial?',
      options: ['Un mes de seguimiento', 'Un día', 'Diez años', 'Nunca'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Plantillas bancarias ayudan a...?',
      options: ['Gastar más', 'Estructurar el presupuesto', 'Evitar impuestos', 'Solo empresas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: 'Tras crear presupuesto, ¿qué evitar?',
      options: ['Revisarlo', 'No revisarlo nunca', 'Ajustar', 'Registrar'],
      correctIndex: 1,
    ),
  ],
  '¿Qué es emprender?': [
    PillQuizData(
      question: '¿Qué barrera cultural menciona España?',
      options: ['Exceso apoyo', 'Miedo al fracaso y trámites', 'Sin autónomos', 'Sin bancos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué financiación pública existe?',
      options: ['Ninguna', 'ENISA, ICO, ayudas autonómicas', 'Solo lotería', 'Solo IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué separar finanzas personales y negocio?',
      options: ['No es necesario', 'Claridad y control fiscal', 'Evitar clientes', 'Subir IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué incluye dar de alta actividad?',
      options: ['Solo Instagram', 'Hacienda y Seguridad Social', 'Solo banco', 'Nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error al emprender?',
      options: ['Validar idea', 'No calcular cuota autónomos e impuestos', 'Plan de negocio', 'Asesoramiento'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Ventaja de ser tu propio jefe?',
      options: ['Sin riesgos', 'Decisiones propias y flexibilidad', 'Sin impuestos', 'Salario fijo garantizado'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Dónde buscar asesoramiento?',
      options: ['Solo redes', 'Cámaras de comercio y bancos', 'Ningún sitio', 'Solo amigos'],
      correctIndex: 1,
    ),
  ],
  'Detecta oportunidades': [
    PillQuizData(
      question: '¿Qué tendencia social en España?',
      options: ['Sin digitalización', 'Envejecimiento, sostenibilidad, digitalización', 'Sin turismo', 'Sin servicios'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cómo validar idea?',
      options: ['Lanzar sin prueba', 'Encuestas y prototipos con clientes', 'Solo intuición', 'Copiar sin adaptar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error al emprender por moda?',
      options: ['Analizar demanda real', 'Entrar sin demanda', 'Observar mercado', 'Escuchar clientes'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué preguntar a clientes potenciales?',
      options: ['Solo precio', 'Problemas y necesidades no resueltas', 'Color favorito', 'Nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Adaptar idea al contexto local implica...?',
      options: ['Ignorar legislación', 'Idioma, cultura y normativa local', 'Solo copiar extranjero', 'Sin competencia'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Ejemplo oportunidad por cambio social?',
      options: ['Servicios para mayores', 'Vender solo CDs', 'Ignorar digital', 'Sin análisis'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Analizar competencia para...?',
      options: ['Copiar mal', 'Ver qué mejorar', 'Ignorar mercado', 'Subir precios sin valor'],
      correctIndex: 1,
    ),
  ],
  'Plan de negocio': [
    PillQuizData(
      question: '¿Para qué piden bancos un plan de negocio?',
      options: ['Decoración', 'Evaluar financiación y viabilidad', 'Solo marketing', 'Evitar impuestos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué incluye plan de operaciones?',
      options: ['Solo logo', 'Recursos humanos, proveedores, logística', 'Solo Instagram', 'Nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué sección analiza clientes y competencia?',
      options: ['Análisis de mercado', 'Solo portada', 'Solo CV', 'Anexo fotos'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Error con cifras del plan?',
      options: ['Ser realista', 'Sobreestimar ingresos', 'Incluir gastos', 'Riesgos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Plan de contingencia sirve para...?',
      options: ['Ignorar problemas', 'Anticipar riesgos', 'Gastar más', 'Solo impresionar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Feedback de mentores ayuda a...?',
      options: ['Empeorar plan', 'Refinar estrategia', 'Evitar clientes', 'No pagar impuestos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Plan de negocio es...?',
      options: ['Solo trámite olvidable', 'Hoja de ruta viva del proyecto', 'Solo para Instagram', 'Opcional siempre'],
      correctIndex: 1,
    ),
  ],
  'Aprende de los errores': [
    PillQuizData(
      question: '¿Qué hacer tras un error empresarial?',
      options: ['Ocultarlo', 'Analizar qué salió mal y mejorar', 'Culpar solo al mercado', 'Repetir igual'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Por qué no castigarse excesivamente?',
      options: ['Enfocarse en solución', 'Ignorar aprendizaje', 'Cerrar siempre', 'No cambiar'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Red de apoyo incluye...?',
      options: ['Solo competencia', 'Emprendedores, mentores, asociaciones', 'Nadie', 'Solo Hacienda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Fracaso es...?',
      options: ['Siempre el final', 'Oportunidad de aprender', 'Vergüenza sin valor', 'Evitar emprender'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Compartir errores en red ayuda a...?',
      options: ['Competir mal', 'Aprendizaje colectivo', 'Evitar clientes', 'Subir impuestos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Grandes emprendedores...?',
      options: ['Nunca fallan', 'Han fracasado antes de triunfar', 'Sin errores', 'Solo suerte'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cambiar tras fracaso implica...?',
      options: ['Repetir exactamente igual', 'Ajustar estrategia con aprendizaje', 'Abandonar siempre', 'Ignorar feedback'],
      correctIndex: 1,
    ),
  ],
  'Crea tu pitch': [
    PillQuizData(
      question: '¿Qué incluir en pitch efectivo?',
      options: ['Solo logo', 'Problema, solución, equipo, modelo', 'Solo precio', 'Currículum largo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Llamada a la acción al final?',
      options: ['No necesaria', 'Invertir, colaborar o probar producto', 'Solo despedida', 'Silencio'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Adaptar pitch según audiencia?',
      options: ['Siempre igual', 'Sí, inversores vs clientes', 'Solo en inglés', 'Sin datos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error común en pitch?',
      options: ['Datos concretos', 'Mucha idea, poco mercado/equipo', 'Practicar', 'Pasión'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Practicar pitch hasta...?',
      options: ['No practicar', 'Dominarlo en ~1 minuto', 'Solo leer', '30 minutos mínimo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Ejemplos y datos concretos...?',
      options: ['Confunden', 'Dan credibilidad', 'Sobran', 'Solo en plan largo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Un buen pitch transmite...?',
      options: ['Solo tecnología', 'Visión clara y convincente', 'Solo redes', 'Miedo'],
      correctIndex: 1,
    ),
  ],
  'Deuda buena vs mala': [
    PillQuizData(
      question: '¿Ejemplo de deuda mala?',
      options: ['Hipoteca vivienda habitual', 'Préstamo rápido para vacaciones', 'Préstamo estudios', 'Financiación negocio rentable'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué es TAE?',
      options: ['Tipo sin comisiones', 'Coste total anual incluyendo comisiones', 'Solo Euríbor', 'Impuesto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Deuda buena suele tener...?',
      options: ['Intereses altísimos', 'Intereses más bajos y valor futuro', 'Plazo 1 día', 'Sin contrato'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error con deudas?',
      options: ['Comparar condiciones', 'Pedir préstamo para pagar otro sin plan', 'Leer contrato', 'Calcular ratio'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Financiar coche de lujo innecesario es...?',
      options: ['Deuda buena', 'Deuda mala típica', 'Inversión', 'Sin intereses'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Tarjeta a plazos para consumo suele ser...?',
      options: ['Deuda buena', 'Deuda mala', 'Ahorro', 'Inversión'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Herramienta para comparar préstamos?',
      options: ['Simuladores bancarios online', 'Solo publicidad', 'Lotería', 'Ninguna'],
      correctIndex: 0,
    ),
  ],
  'Método bola de nieve': [
    PillQuizData(
      question: '¿Alternativa que prioriza interés alto?',
      options: ['Bola de nieve', 'Avalancha (mayor interés primero)', 'Ignorar deudas', 'Solo mínimos siempre'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué hacer al liquidar primera deuda?',
      options: ['Gastar cuota liberada', 'Atacar siguiente deuda pequeña', 'Pedir más crédito', 'Parar pagos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Orden típico de lista bola de nieve?',
      options: ['Mayor a menor', 'Menor a mayor importe pendiente', 'Alfabético', 'Aleatorio'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error durante el método?',
      options: ['Seguir usando tarjetas', 'Programar pagos automáticos', 'Ajustar presupuesto', 'Lista de deudas'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Ventaja psicológica?',
      options: ['Victorias rápidas al eliminar deudas', 'Menos motivación', 'Más deudas', 'Sin orden'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Asociaciones de ayuda?',
      options: ['ADICAE, OCU', 'Solo bancos centrales', 'Ninguna', 'Solo lotería'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Pagos automáticos ayudan a...?',
      options: ['Olvidar cuotas', 'No olvidar cuotas mínimas', 'Subir intereses', 'Evitar pagar'],
      correctIndex: 1,
    ),
  ],
  'Historial crediticio': [
    PillQuizData(
      question: '¿Qué perjudica historial?',
      options: ['Pagar a tiempo', 'Impagos y retrasos', 'Una cuenta', 'Ahorrar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿CIRBE registra...?',
      options: ['Solo depósitos', 'Préstamos y riesgos con bancos', 'Vacaciones', 'IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Mejor historial permite...?',
      options: ['Peores condiciones', 'Mejores tipos y más crédito', 'Sin hipoteca', 'Evitar IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error grave?',
      options: ['Consultar historial', 'Pedir préstamos a nombre ajeno', 'Pagar puntual', 'Negociar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿ASNEF es...?',
      options: ['Fichero de morosos', 'Tipo de hipoteca', 'Plan pensiones', 'IVA'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Hablar con banco antes de impago...?',
      options: ['Inútil', 'Puede evitar agraviar situación', 'Ilegal', 'Solo después de embargo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Abuso de crédito rápido...?',
      options: ['Mejora historial', 'Lo deteriora', 'Sin efecto', 'Sube nómina'],
      correctIndex: 1,
    ),
  ],
  'Evita el sobreendeudamiento': [
    PillQuizData(
      question: '¿Qué es efecto bola de nieve de deudas?',
      options: ['Ahorro creciente', 'Pedir crédito para pagar crédito', 'Inversión', 'Plan pensiones'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Ratio de endeudamiento mide...?',
      options: ['Solo hipoteca', 'Cuotas de deuda vs ingresos netos', 'Solo tarjetas', 'Patrimonio'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Consecuencia grave del sobreendeudamiento?',
      options: ['Más ahorro', 'Embargos y ficheros morosos', 'Mejor crédito', 'Subida salarial'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Fondo emergencia evita...?',
      options: ['Todo', 'Recurrir al crédito por imprevistos', 'IRPF', 'IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Dónde acudir si hay problemas?',
      options: ['Ignorar', 'Banco y asociaciones como ADICAE', 'Más préstamos', 'Solo redes'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Comparar ofertas antes de endeudarse?',
      options: ['No importa', 'Sí, evita condiciones abusivas', 'Solo la primera', 'Solo publicidad'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Señal de alerta?',
      options: ['Cuotas >35-40% ingresos', 'Ahorro alto', 'Sin deudas', 'Pago puntual'],
      correctIndex: 0,
    ),
  ],
  'Auditoría de deudas': [
    PillQuizData(
      question: '¿Primer paso de auditoría?',
      options: ['Pedir más crédito', 'Listar todas las deudas con detalle', 'Ignorar pequeñas', 'Cerrar cuentas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Deudas pequeñas olvidadas?',
      options: ['No importan', 'Sí, incluir tarjetas y familiares', 'Solo hipoteca', 'Ninguna'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Ordenar deudas puede ser por...?',
      options: ['Color', 'Importe, interés o urgencia', 'Solo banco', 'Azar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Renegociar condiciones...?',
      options: ['Imposible', 'Posible con banco o reunificación', 'Solo Hacienda', 'Ilegal'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Herramienta para control?',
      options: ['Solo memoria', 'Hoja de cálculo o app', 'Nada', 'Lotería'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Calcular coste mensual total sirve para...?',
      options: ['Gastar más', 'Ver carga real de deuda', 'Evitar pagar', 'Subir intereses'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Revisar contratos evita...?',
      options: ['Entender condiciones', 'Sorpresas con cláusulas', 'Pagar', 'Todo'],
      correctIndex: 1,
    ),
  ],
  '¿Qué es un seguro?': [
    PillQuizData(
      question: '¿Qué es la indemnización?',
      options: ['Pago de prima', 'Compensación por siniestro cubierto', 'Franquicia', 'Exclusión'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Seguro hogar con hipoteca?',
      options: ['Opcional siempre', 'Suele ser obligatorio', 'Prohibido', 'Solo vida'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Qué cubre responsabilidad civil en hogar?',
      options: ['Solo robo', 'Daños a terceros', 'Vacaciones', 'Nómina'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Error al contratar?',
      options: ['Comparar ofertas', 'Contratar sin leer exclusiones', 'Revisar coberturas', 'Actualizar capitales'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Seguro de coche mínimo legal?',
      options: ['Todo riesgo', 'Responsabilidad civil (terceros)', 'Vida', 'Hogar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Actualizar capitales asegurados?',
      options: ['Innecesario', 'Importante con el tiempo', 'Ilegal', 'Solo una vez'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Sistema público en España cubre...?',
      options: ['Todo sin límites', 'Mucho pero no todo (ej. sanidad con listas)', 'Nada', 'Solo empresas'],
      correctIndex: 1,
    ),
  ],
  'Seguro de salud': [
    PillQuizData(
      question: '¿Limitación sanidad pública?',
      options: ['Sin médicos', 'Listas de espera en algunos casos', 'Gratuita siempre instantánea', 'Sin hospitales'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Periodo de carencia?',
      options: ['Pago extra', 'Tiempo antes de cubrir ciertos servicios', 'Prima anual', 'Franquicia'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿No declarar preexistencias puede...?',
      options: ['Mejorar precio siempre', 'Causar exclusiones o anulación', 'Obligatorio ocultar', 'Subir nómina'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Servicio no siempre público?',
      options: ['Urgencias', 'Fisioterapia o psicología privada', 'Médico familia', 'Hospital público'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Comparar compañías para...?',
      options: ['Pagar más', 'Ajustar cobertura y precio', 'Evitar seguro', 'Solo marca'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Seguro salud complementa...?',
      options: ['Solo ocio', 'Sanidad pública', 'IRPF', 'IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Contratar solo por precio?',
      options: ['Ideal', 'Riesgo de cobertura insuficiente', 'Obligatorio', 'Sin riesgo'],
      correctIndex: 1,
    ),
  ],
  'Seguro de vida': [
    PillQuizData(
      question: '¿Cómo calcular capital necesario?',
      options: ['Al azar', 'Deudas + gastos familiares x años', 'Solo 1.000€', 'Sin cálculo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Seguro riesgo puro cubre...?',
      options: ['Solo ahorro', 'Fallecimiento', 'Vacaciones', 'Coche'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Quién recibe indemnización vida?',
      options: ['Aseguradora', 'Beneficiarios designados', 'Banco siempre', 'Hacienda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Actualizar beneficiarios tras divorcio?',
      options: ['Opcional irrelevante', 'Muy importante', 'Prohibido', 'Automático'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Seguro vida útil con hipoteca?',
      options: ['Nunca', 'Para cubrir deuda si faltas', 'Solo solteros', 'Obligatorio siempre'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Capital insuficiente implica...?',
      options: ['Protección completa', 'Familia con menos respaldo', 'Sin prima', 'Más cobertura'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Simuladores online ayudan a...?',
      options: ['Evitar seguro', 'Estimar capital adecuado', 'Subir IRPF', 'No pagar'],
      correctIndex: 1,
    ),
  ],
  'Compara seguros': [
    PillQuizData(
      question: '¿Qué comparar además de precio?',
      options: ['Solo color póliza', 'Coberturas, límites y franquicias', 'Nada más', 'Solo marca'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Límite de indemnización es...?',
      options: ['Prima', 'Máximo que paga aseguradora', 'Franquicia', 'Exclusión'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Comparadores online sirven para...?',
      options: ['Solo publicidad', 'Varias ofertas rápidamente', 'Evitar seguro', 'Solo vida'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Opiniones de clientes ayudan a...?',
      options: ['Nada', 'Evaluar servicio en siniestros', 'Subir prima', 'Evitar póliza'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Seguro barato sin cobertura...?',
      options: ['Siempre mejor', 'Puede salir caro en siniestro', 'Obligatorio', 'Sin riesgo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Preguntar exclusiones implica...?',
      options: ['Saber qué NO cubre', 'Solo marketing', 'Subir IRPF', 'Cancelar seguro'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Atención al cliente importa en...?',
      options: ['Solo compra', 'Gestión de siniestros', 'Nunca', 'Solo coche'],
      correctIndex: 1,
    ),
  ],
  'Revisa tus pólizas': [
    PillQuizData(
      question: '¿Qué cambio vital exige revisar seguros?',
      options: ['Nada', 'Nacimiento hijo, mudanza, coche nuevo', 'Solo cumpleaños', 'Cambio estación'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Renovación anual puede traer...?',
      options: ['Siempre mismo precio', 'Cambio de prima o condiciones', 'Sin contrato', 'Cancelación auto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Pagar coberturas que no necesitas...?',
      options: ['Ahorro', 'Gasto innecesario', 'Obligatorio', 'Mejor protección siempre'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Lista de todos los seguros ayuda a...?',
      options: ['Olvidar', 'Visión global de protección', 'Gastar más', 'Evitar comparar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Contactar aseguradora sirve para...?',
      options: ['Solo quejas', 'Actualizar datos y dudas', 'Subir IRPF', 'Cancelar todo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Marcar fecha anual en calendario...?',
      options: ['Inútil', 'Recordatorio de revisión', 'Solo empresas', 'Ilegal'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Descubrir tarde mala cobertura...?',
      options: ['Sin problema', 'Sorpresa grave en siniestro', 'Mejor', 'Obligatorio'],
      correctIndex: 1,
    ),
  ],
  'Establece metas financieras': [
    PillQuizData(
      question: '¿Qué significa la M en SMART?',
      options: ['Medible (con cifra)', 'Mensual siempre', 'Mínimo', 'Máximo'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Meta corto plazo ejemplo?',
      options: ['Jubilación', 'Fondo emergencia o vacaciones <1 año', 'Independencia 20 años', 'Herencia'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Meta alcanzable implica...?',
      options: ['Imposible siempre', 'Realista con tus ingresos', 'Sin fecha', 'Sin cifra'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Escribir metas y visible ayuda a...?',
      options: ['Olvidar', 'Mantener enfoque', 'Gastar más', 'Evitar ahorro'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Subcuentas por objetivo en bancos...?',
      options: ['No existen', 'Facilitan seguimiento (ING, Openbank)', 'Solo empresas', 'Ilegal'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Meta sin fecha límite suele...?',
      options: ['Cumplirse sola', 'Postergarse indefinidamente', 'Ser SMART', 'Ahorrar más'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿3.000€ en 12 meses requiere...?',
      options: ['100€/mes', '250€/mes', '500€/mes', '50€/mes'],
      correctIndex: 1,
    ),
  ],
  'Corto, medio y largo plazo': [
    PillQuizData(
      question: '¿Riesgo de solo corto plazo?',
      options: ['Mucha riqueza futura', 'No acumular patrimonio', 'Mejor jubilación', 'Sin gastos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Riesgo de solo largo plazo?',
      options: ['Sin motivación y necesidades actuales', 'Demasiado ahorro', 'Sin inversiones', 'Mejor liquidez'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿40% ahorro mensual a corto en ejemplo?',
      options: ['40% del ahorro total', '40% del salario bruto', '40€ fijos', 'Nada'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Producto medio plazo?',
      options: ['Efectivo casa', 'Fondos conservadores', 'Solo lotería', 'Cuenta sin interés'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Revisar distribución cada año...?',
      options: ['Innecesario', 'Ajustar a situación vital', 'Solo una vez', 'Prohibido'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿300€ ahorro, 30% largo plazo = ?',
      options: ['30€', '90€', '120€', '150€'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Equilibrio tres horizontes es...?',
      options: ['Complicar sin sentido', 'Base de planificación sana', 'Solo bancos', 'Solo ricos'],
      correctIndex: 1,
    ),
  ],
  'Crea tu plan financiero': [
    PillQuizData(
      question: '¿Qué son pasivos en el plan?',
      options: ['Lo que tienes', 'Lo que debes (deudas)', 'Solo ingresos', 'Solo gastos ocio'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Flujo de caja positivo significa...?',
      options: ['Gastas más', 'Ingresos superan gastos', 'Sin deuda', 'Sin activos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Balance neto negativo indica...?',
      options: ['Debes más de lo que tienes', 'Riqueza total', 'Sin acción', 'Solo IRPF'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Priorizar metas por...?',
      options: ['Color', 'Urgencia e importancia', 'Azar', 'Solo ocio'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Plan sencillo actualizado vs perfecto olvidado?',
      options: ['Perfecto olvidado mejor', 'Sencillo y usado vale más', 'Ninguno sirve', 'Solo papel'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Inventario incluye...?',
      options: ['Solo deudas', 'Activos e inversiones también', 'Solo ocio', 'Nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Seguimiento cada 3-6 meses...?',
      options: ['Excesivo', 'Recomendado', 'Nunca', 'Solo jubilación'],
      correctIndex: 1,
    ),
  ],
  'Revisa y ajusta tu plan': [
    PillQuizData(
      question: '¿Cita financiera mensual dura...?',
      options: ['5 horas', '~30 minutos', '1 semana', '0 minutos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Al alcanzar meta, qué hacer?',
      options: ['Parar planificar', 'Celebrar y fijar siguiente meta', 'Gastar todo', 'Ignorar'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿2 meses sin ahorrar es...?',
      options: ['Normal siempre', 'Señal de alerta', 'Obligatorio', 'Meta SMART'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Deudas >10% interés son...?',
      options: ['Prioridad reducir', 'Ignorar', 'Buenas siempre', 'Sin coste'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Cambio de trabajo exige...?',
      options: ['Ignorar plan', 'Revisar ingresos y plan', 'Solo vacaciones', 'Cerrar cuentas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Rendimiento inversión bajo esperado...?',
      options: ['Nunca revisar', 'Revisar estrategia', 'Retirar todo impulsivo', 'Sin plan'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Metas pueden cambiar con...?',
      options: ['Nunca', 'Matrimonio, hijos, herencia, etc.', 'Solo edad', 'Solo banco'],
      correctIndex: 1,
    ),
  ],
  'Simula tu futuro financiero': [
    PillQuizData(
      question: '¿200€/mes 30 años al 6% ≈ total aportado?',
      options: ['48.000€', '72.000€', '201.000€', '20.000€'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Esperar 10 años menos a invertir implica...?',
      options: ['Mismo resultado', 'Perder gran parte del interés compuesto', 'Más capital', 'Menos riesgo solo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Herramienta simular en España?',
      options: ['Solo papel', 'Rankia, simuladores fondos', 'Lotería', 'Ninguna'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿50€/mes a los 25 vs 200€ a los 45?',
      options: ['Igual siempre', 'Empezar joven compensa tiempo', 'Mejor esperar', 'Sin diferencia'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Interés compuesto en simulación...?',
      options: ['Solo capital inicial', 'Aportaciones + rendimientos reinvertidos', 'Solo impuestos', 'Solo IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿201.000€ en ejemplo incluye...?',
      options: ['Solo aportaciones', 'Aportaciones + rendimientos', 'Solo suerte', 'Solo IRPF devuelto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Conclusión principal del desafío?',
      options: ['Esperar siempre', 'Empezar hoy aunque sea poco', 'Solo grandes sumas', 'No invertir'],
      correctIndex: 1,
    ),
  ],
  '¿Por qué gastamos más de la cuenta?': [
    PillQuizData(
      question: '¿Gratificación inmediata implica...?',
      options: ['Preferir recompensa ahora vs después', 'Más ahorro', 'Sin compras', 'Solo inversiones'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Cuánto más se gasta con tarjeta vs efectivo (estudios)?',
      options: ['Menos', 'Hasta ~83% más', 'Igual siempre', '0%'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Comparación social en redes...?',
      options: ['Reduce gasto', 'Presión de consumo innecesaria', 'Sin efecto', 'Solo ahorro'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Gasto emocional crea...?',
      options: ['Círculo vicioso', 'Riqueza automática', 'Menos deuda', 'Más IRPF'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Dolor de pagar menor con móvil/tarjeta...?',
      options: ['Gastas más fácilmente', 'Gastas menos', 'Sin efecto', 'Solo efectivo'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Pregunta antes de comprar no esencial?',
      options: ['¿Lo necesito o solo quiero ahora?', '¿Es la marca más cara?', '¿Puedo endeudarme?', '¿Lo compra mi vecino?'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Problemas financieros son a menudo...?',
      options: ['Solo matemáticos', 'Psicológicos y emocionales', 'Solo legales', 'Sin solución'],
      correctIndex: 1,
    ),
  ],
  'Sesgos cognitivos y dinero': [
    PillQuizData(
      question: '¿Sesgo confirmación implica...?',
      options: ['Buscar info que confirma creencias', 'Diversificar', 'Automatizar', 'Plan escrito'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Exceso de confianza lleva a...?',
      options: ['Mejor que índice', 'Peores resultados que fondo indexado', 'Sin riesgo', 'Más diversificación'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Política inversión escrita ayuda a...?',
      options: ['Improvisar', 'Seguir reglas y evitar impulsos', 'Especular más', 'Ignorar mercado'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Sesgo presente valoriza...?',
      options: ['Futuro sobre presente', 'Presente sobre futuro', 'Solo ahorro', 'Solo deuda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Combatir sesgos con automatización...?',
      options: ['Empeora', 'Reduce decisiones impulsivas', 'Sin efecto', 'Solo ricos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Buffett recomienda opuesto a manada...?',
      options: ['Comprar en euforia', 'Ser cauteloso cuando otros codiciosos', 'Seguir modas', 'Vender nunca'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Mantener inversión perdedora por aversión...?',
      options: ['Siempre racional', 'Sesgo común a evitar', 'Obligatorio', 'Mejor estrategia'],
      correctIndex: 1,
    ),
  ],
  'El coste emocional del dinero': [
    PillQuizData(
      question: '¿Estrés financiero afecta...?',
      options: ['Solo bolsillo', 'Salud, sueño y decisiones', 'Solo impuestos', 'Nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Círculo vicioso del estrés?',
      options: ['Poco dinero → estrés → malas decisiones', 'Ahorro → estrés', 'Inversión → paz', 'Deuda → riqueza'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Transparencia sobre situación...?',
      options: ['Empeora', 'Reduce autoengaño y ansiedad', 'Inútil', 'Ilegal'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Plan pequeño de acción...?',
      options: ['Inútil', 'Reduce ansiedad', 'Solo deuda', 'Sin efecto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Red de apoyo incluye OCU/ADICAE...?',
      options: ['Sí', 'No existen', 'Solo bancos privados', 'Nadie'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Desconexión digital si presiona gasto...?',
      options: ['Mala idea', 'Puede ayudar', 'Obligatorio', 'Sin efecto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Hablar de dinero en pareja...?',
      options: ['Evitar siempre', 'Mejora comunicación y conflictos', 'Ilegal', 'Sin beneficio'],
      correctIndex: 1,
    ),
  ],
  'Cómo mejorar tu disciplina financiera': [
    PillQuizData(
      question: '¿Disciplina financiera es más...?',
      options: ['Solo fuerza voluntad', 'Diseño de entorno', 'Suerte', 'IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Fraccionar meta 10.000€ en...?',
      options: ['Un solo año imposible', 'Metas mensuales manejables', 'Ignorar', 'Deuda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Regla 24h para compras >50€...?',
      options: ['Comprar más', '80% veces no comprarás', 'Obligatorio legal', 'Sin efecto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Cuenta ahorro difícil acceso...?',
      options: ['Gastar más fácil', 'Menos tentación de tocar ahorro', 'Sin ahorro', 'Más deuda'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Recompensas al cumplir metas...?',
      options: ['Malas siempre', 'Refuerzo positivo útil', 'Prohibidas', 'Sin efecto'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Un cambio de hábito 30 días...?',
      options: ['Cambiar todo a la vez', 'Empezar con uno solo', 'Ninguno', 'Solo en enero'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Automatizar día de cobro...?',
      options: ['Si dinero no pasa por manos, menos gasto', 'Gastar antes', 'Sin ahorro', 'Más impuestos'],
      correctIndex: 0,
    ),
  ],
  'Diseña tus hábitos financieros': [
    PillQuizData(
      question: '¿Señal en ciclo hábito ahorro?',
      options: ['Llega la nómina', 'Gastar todo', 'Dormir', 'IVA'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Registro gastos 30 días sirve para...?',
      options: ['Gastar más', 'Conocer patrones', 'Evitar banco', 'Subir IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Contenido financiero 15 min/día...?',
      options: ['Pérdida tiempo', 'Educación continua', 'Solo expertos', 'Prohibido'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Competidor en finanzas personales?',
      options: ['Tu vecino', 'Tú de hace un año', 'Solo el banco', 'Nadie'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Recompensa en ciclo hábito?',
      options: ['Ver saldo crecer y seguridad', 'Gastar deuda', 'Multa', 'IRPF'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Libro recomendado español?',
      options: ['La psicología del dinero', 'Solo novela', 'Ninguno', 'Solo tabloides'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Implementar un hábito 30 días antes del siguiente...?',
      options: ['Todos a la vez', 'Automatizar uno primero', 'Nunca', 'Solo cinco'],
      correctIndex: 1,
    ),
  ],
  '¿Comprar o alquilar?': [
    PillQuizData(
      question: '¿Ventaja comprar frente inflación alquiler?',
      options: ['Siempre peor', 'Protección patrimonial', 'Sin costes', 'Más flexibilidad'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Alquilar libera capital para...?',
      options: ['Solo ocio', 'Invertir en otros activos', 'Pagar IVA', 'Nada'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Esfuerzo vivienda/salario en España...?',
      options: ['Bajo en Europa', 'Entre los más altos', 'Sin datos', 'Cero'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿En Madrid/BCN a corto plazo...?',
      options: ['Alquilar puede ser más barato', 'Comprar siempre más barato', 'Igual siempre', 'Sin vivienda'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Estabilidad laboral dudosa favorece...?',
      options: ['Comprar ya', 'Alquilar más prudente', 'Dos hipotecas', 'Sin plan'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Gastos mantenimiento propietario...?',
      options: ['Los paga inquilino siempre', 'IBI, comunidad, reparaciones', 'Ninguno', 'Solo inquilino'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Regla 5-7 años para comprar...?',
      options: ['Permanencia mínima razonable', 'Comprar por 1 mes', 'Solo extranjeros', 'Ley obligatoria'],
      correctIndex: 0,
    ),
  ],
  'Cómo funciona la hipoteca': [
    PillQuizData(
      question: '¿Capital hipotecado típico?',
      options: ['100% siempre', 'Hasta ~80% valor tasación', '50% máximo', '200%'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Hipoteca variable referencia...?',
      options: ['IBI', 'Euríbor + diferencial', 'IVA', 'IRPF'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Euríbor alto en 2023-24 implicó...?',
      options: ['Cuotas más bajas', 'Cuotas más altas para muchos', 'Sin cambio', 'Sin hipotecas'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿TIN vs TAE?',
      options: ['TAE incluye más costes', 'TIN siempre mayor', 'Iguales', 'TAE sin comisiones'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Vivienda nueva lleva...?',
      options: ['Solo ITP', 'IVA 10% (general)', 'Sin impuestos', 'Solo AJD sin IVA'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Garantía en hipoteca?',
      options: ['Ninguna', 'El inmueble', 'Solo nómina', 'Coche'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Efectivo necesario además del 20%?',
      options: ['Nada más', '~10% gastos compra aprox.', '50% más', 'Solo 5%'],
      correctIndex: 1,
    ),
  ],
  'Gastos ocultos al comprar vivienda': [
    PillQuizData(
      question: '¿ITP en vivienda usada varía por...?',
      options: ['Marca coche', 'Comunidad autónoma', 'Edad comprador', 'Mes'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿AJD aplica a...?',
      options: ['Solo alquiler', 'Vivienda nueva (documentos)', 'Salario', 'Comida'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿IBI lo paga...?',
      options: ['Inquilino siempre', 'Propietario anualmente', 'Banco', 'Hacienda al comprador una vez'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Mantenimiento recomendado reservar...?',
      options: ['0%', '~1% valor vivienda anual', '50%', 'Solo primer mes'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Ejemplo 200.000€ Madrid: ITP ~12.000€ más otros...?',
      options: ['Total ~15.000€ extras plausible', 'Solo 500€', 'Cero', '1 millón'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Tasación bancaria cuesta...?',
      options: ['300-500€ aprox.', 'Gratis siempre', '10% precio', 'Sin tasación'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Pedir estimación escrita antes firmar...?',
      options: ['Innecesario', 'Evita sorpresas', 'Ilegal', 'Solo vendedor'],
      correctIndex: 1,
    ),
  ],
  'La vivienda como inversión': [
    PillQuizData(
      question: '¿Apalancamiento inmobiliario significa...?',
      options: ['Comprar 200.000€ con parte propia y crédito', 'Sin deuda', 'Solo efectivo', 'Alquilar siempre'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Yield bruto 5% significa...?',
      options: ['Alquiler anual / precio compra', 'Precio / alquiler', 'Solo gastos', 'IBI solo'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Concentrar solo en vivienda...?',
      options: ['Diversificación ideal', 'Alto riesgo concentrado', 'Sin gestión', 'Liquidez alta'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Rentabilidad neta inmobiliaria vs fondo global...?',
      options: ['Vivienda siempre superior neta', 'A menudo fondo global compite mejor', 'Igual siempre', 'Sin datos'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Inversión alquiler implica...?',
      options: ['Gestión inquilinos y reparaciones', 'Sin trabajo', 'Solo cobrar', 'Sin impuestos'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Cuándo tiene sentido invertir inmuebles?',
      options: ['Sin vivienda propia siempre', 'Con patrimonio diversificado y conocimiento', 'Siempre único activo', 'Nunca'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Inflación a largo plazo y vivienda...?',
      options: ['Protección relativa del activo', 'Sin relación', 'Siempre pierde', 'Solo alquiler'],
      correctIndex: 0,
    ),
  ],
  'Simula tu hipoteca': [
    PillQuizData(
      question: '¿Cuota ~880€ ejemplo implica total banco...?',
      options: ['176.000€', '264.000€ en 25 años', '220.000€', '88.000€'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Amortización anticipada...?',
      options: ['Prohibida', 'Reduce intereses totales', 'Sube intereses', 'Sin comisión nunca'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Coste real vivienda 220.000€ con intereses...?',
      options: ['220.000€', '~334.400€ en ejemplo', '176.000€', '88.000€'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Capital propio = entrada + gastos...?',
      options: ['Sí (~70.400€ en ejemplo)', 'Solo hipoteca', 'Solo intereses', 'Solo ITP'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Simulador Banco de España en...?',
      options: ['bankofspain.es', 'Solo apps juego', 'Ningún sitio', 'Solo notaría'],
      correctIndex: 0,
    ),
    PillQuizData(
      question: '¿Firmar sin calcular coste total...?',
      options: ['Recomendado', 'Error grave', 'Obligatorio', 'Sin riesgo'],
      correctIndex: 1,
    ),
    PillQuizData(
      question: '¿Plazo más corto asumible...?',
      options: ['Más intereses', 'Menos intereses totales', 'Sin cuota', 'Misma cuota siempre'],
      correctIndex: 1,
    ),
  ],
};

/// Returns extra quiz questions for a pill title, or empty list if unknown.
List<PillQuizData> extraQuizzesFor(String pillTitle) {
  return pillQuizExtras[pillTitle] ?? const [];
}

