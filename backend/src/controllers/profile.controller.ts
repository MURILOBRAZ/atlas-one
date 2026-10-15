import type { FastifyReply, FastifyRequest } from 'fastify';
import type { UpdateProfileInput } from '../models/employee.js';
import { getCurrentProfile, updateCurrentProfile } from '../services/profile.service.js';

export async function getProfile(_request: FastifyRequest, reply: FastifyReply) {
  const profile = await getCurrentProfile();
  return reply.send(profile);
}

export async function updateProfile(
  request: FastifyRequest<{ Body: UpdateProfileInput }>,
  reply: FastifyReply,
) {
  const profile = await updateCurrentProfile(request.body);
  return reply.send(profile);
}
