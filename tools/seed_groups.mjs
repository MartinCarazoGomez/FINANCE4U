import { getAccessToken } from 'file:///C:/Users/marti/AppData/Roaming/npm/node_modules/firebase-tools/lib/auth.js';

const projectId = 'finance4u-app-v1';
const groups = [
  { id: 'class-0001', code: '0001', name: 'Clase 0001' },
  { id: 'class-0002', code: '0002', name: 'Clase 0002' },
  { id: 'class-0003', code: '0003', name: 'Clase 0003' },
];

const { access_token: accessToken } = await getAccessToken({}, []);

for (const g of groups) {
  const url =
    `https://firestore.googleapis.com/v1/projects/${projectId}` +
    `/databases/(default)/documents/groups?documentId=${g.id}`;

  const body = {
    fields: {
      code: { stringValue: g.code },
      name: { stringValue: g.name },
      pin: { stringValue: '000000' },
      memberIds: { arrayValue: { values: [] } },
    },
  };

  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });

  const text = await res.text();
  if (!res.ok) {
    throw new Error(`Failed ${g.code} (${res.status}): ${text}`);
  }
  console.log(`OK ${g.code} -> ${g.name}`);
}
