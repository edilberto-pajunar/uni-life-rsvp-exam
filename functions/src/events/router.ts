import { Router } from "express";
import { db } from "../config/firebase-admin";
import { Event } from "./interface";

export const eventsRouter = Router();

eventsRouter.get("/", async (_req, res) => {
  try {
    const snapshot = await db.collection("events").get();

    const events: Event[] = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json({ success: true, data: events, message: "Events fetched successfully." });
  } catch (error) {
    res.status(500).json({ success: false, data: {}, message: "Failed to fetch events." });
  }
});
