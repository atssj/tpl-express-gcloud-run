import type { Request, Response, Application } from 'express';
import express from 'express';

const app: Application = express();
const port: string | number = process.env.PORT || 8080;

// A simple "Hello World" endpoint.
app.get('/', (req: Request, res: Response) => {
  res.send('Hello, World!');
});

app.listen(port, () => {
  // The 'toString()' is added for type safety in case 'port' is a number.
  console.log(`Server listening on port ${port.toString()}`);
});
