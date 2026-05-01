import { z } from "zod";

const IceCandidateSchema = z.object({
  type: z.literal("candidate"),
  candidate: z.object({
    candidate: z.string(),
    sdpMid: z.string().nullable(),
    sdpMLineIndex: z.number().nullable(),
  }),
});

const SdpSchema = z.object({
  type: z.union([z.literal("offer"), z.literal("answer")]),
  sdp: z.string(),
});

export const SignalDataSchema = z.union([SdpSchema, IceCandidateSchema]);

export const ForwardSignalBodySchema = z.object({
  action: z.literal("forward_signal"),
  targetConnectionId: z.string().min(1, "targetConnectionId is required"),
  signalData: SignalDataSchema,
});
