import express from "express";
import { eventsRouter } from "./events/router";
import { rateLimit } from "express-rate-limit";

export const api = express();

api.set("trust proxy", 1);

api.use(express.json());
api.use(express.urlencoded({ extended: true }));

api.use(
  rateLimit({
    windowMs: 2 * 60 * 1000, // 2 minutes
    max: 10,
  }),
);

api.use("/health", (request, response) => {
  response.send("OK!");
});

api.use("/events", eventsRouter);
