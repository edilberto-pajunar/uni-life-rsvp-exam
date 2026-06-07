import express from "express";
import { eventsRouter } from "./events/router";

export const api = express();

api.set("trust proxy", 1);

api.use(express.json());
api.use(express.urlencoded({ extended: true }));

// api.use(
//   rateLimit({
//     windowMs: 15 * 60 * 1000,
//     max: 100,
//   }),
// );

api.use("/health", (request, response) => {
  response.send("OK!");
});

api.use("/events", eventsRouter);
