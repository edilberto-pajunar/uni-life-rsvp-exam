import { z } from "zod";

export const rsvpSchema = z.object({
  rsvp: z.boolean(),
});

export type RsvpBody = z.infer<typeof rsvpSchema>;
