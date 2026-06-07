import { Router, Request } from "express";
import { Event } from "../interface";
import { User } from "../../user/user";
import { logger } from "firebase-functions";
import { DUMMY_EVENTS, CURRENT_USER } from "../../utils/constant";
import { rsvpSchema } from "../schema";

export const eventIdRouter = Router({ mergeParams: true });

eventIdRouter.get(
  "/",
  async (req: Request<{ eventId: string }>, res) => {
    const { eventId } = req.params;

    try {
      await new Promise((resolve) => setTimeout(resolve, 2000));

      const dummyEvent = DUMMY_EVENTS.find((e) => e.id === eventId);

      if (!dummyEvent) {
        res
          .status(404)
          .json({ success: false, data: {}, message: "Event not found." });
        return;
      }

      const attendees: User[] = dummyEvent.attendees ?? [];
      const isRsvped = attendees.some((a) => a.id === CURRENT_USER.id);

      const event: Event = {
        ...dummyEvent,
        attendees,
        isRsvped,
      };

      res.json({
        success: true,
        data: event,
        message: "Event fetched successfully.",
      });
    } catch (error) {
      logger.error(error);
      res
        .status(500)
        .json({ success: false, data: {}, message: "Failed to fetch event." });
    }
  },
);

eventIdRouter.post(
  "/rsvp",
  async (req: Request, res) => {
    const parsed = rsvpSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({
        success: false,
        data: {},
        message: "Invalid request body: 'rsvp' boolean is required.",
      });
      return;
    }

    const { rsvp } = parsed.data;
    const { eventId } = req.params as { eventId: string };

    try {
      await new Promise((resolve) => setTimeout(resolve, 2000));

      const dummyEvent = DUMMY_EVENTS.find((e) => e.id === eventId);

      if (!dummyEvent) {
        res
          .status(404)
          .json({ success: false, data: {}, message: "Event not found." });
        return;
      }

      const attendees: User[] = dummyEvent.attendees ?? [];
      const alreadyRsvped = attendees.some((a) => a.id === CURRENT_USER.id);

      if (rsvp && !alreadyRsvped) {
        dummyEvent.attendees = [...attendees, CURRENT_USER];
        dummyEvent.rsvpCount = (dummyEvent.rsvpCount ?? 0) + 1;
      } else if (!rsvp && alreadyRsvped) {
        dummyEvent.attendees = attendees.filter((a) => a.id !== CURRENT_USER.id);
        dummyEvent.rsvpCount = Math.max(0, (dummyEvent.rsvpCount ?? 0) - 1);
      }

      const event: Event = { ...dummyEvent, isRsvped: rsvp };

      res.json({
        success: true,
        data: event,
        message: rsvp ? "RSVP confirmed." : "RSVP cancelled.",
      });
    } catch (error) {
      logger.error(error);
      res
        .status(500)
        .json({ success: false, data: {}, message: "Failed to update RSVP." });
    }
  },
);
