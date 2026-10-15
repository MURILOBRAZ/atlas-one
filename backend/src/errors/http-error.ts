/**
 * Erro com status HTTP conhecido (ex.: 404).
 * Lançado pelos services e convertido em resposta JSON no server.ts.
 */
export class HttpError extends Error {
  readonly statusCode: number;

  constructor(statusCode: number, message: string) {
    super(message);
    this.statusCode = statusCode;
  }
}

export class NotFoundError extends HttpError {
  constructor(message: string) {
    super(404, message);
  }
}
