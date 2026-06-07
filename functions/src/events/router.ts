import { Router } from "express";
import { logger } from "firebase-functions";
import { requiredAuth } from "../middleware/auth";
import { eventIdRouter } from "./[eventId]/router";
import { DUMMY_EVENTS, CURRENT_USER } from "../utils/constant";

export const eventsRouter = Router();

eventsRouter.get("/", requiredAuth, async (_req, res) => {
  try {
    await new Promise((resolve) => setTimeout(resolve, 2000));

    res.json({
      success: true,
      data: DUMMY_EVENTS.map(({ attendees, ...rest }) => ({
        ...rest,
        isRsvped: (attendees ?? []).some((a) => a.id === CURRENT_USER.id),
      })),
      message: "Events fetched successfully.",
    });
  } catch (error) {
    logger.error(error);
    res
      .status(500)
      .json({ success: false, data: {}, message: "Failed to fetch events." });
  }
});

eventsRouter.use("/:eventId", eventIdRouter);
