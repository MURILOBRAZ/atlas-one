import type { FastifyInstance } from 'fastify';
import { getProfile, updateProfile } from '../controllers/profile.controller.js';

// Validação do corpo do PUT /api/profile (JSON Schema, recurso nativo do Fastify).
// Requisições fora deste formato recebem 400 antes de chegar ao controller.
const updateProfileSchema = {
  body: {
    type: 'object',
    required: ['name', 'phone', 'jobTitle'],
    additionalProperties: false,
    properties: {
      // '\\S' exige ao menos um caractere que não seja espaço.
      name: { type: 'string', minLength: 3, maxLength: 120, pattern: '\\S' },
      // Apenas dígitos, espaços, parênteses, '+' e '-'. Pode ser vazio.
      phone: { type: 'string', maxLength: 20, pattern: '^[0-9()+\\- ]*$' },
      jobTitle: { type: 'string', minLength: 2, maxLength: 80, pattern: '\\S' },
    },
  },
};

export async function profileRoutes(app: FastifyInstance) {
  app.get('/profile', getProfile);
  app.put('/profile', { schema: updateProfileSchema }, updateProfile);
}
