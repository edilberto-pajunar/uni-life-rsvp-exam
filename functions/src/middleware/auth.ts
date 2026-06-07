import * as admin from "firebase-admin";
import { NextFunction, Request, Response } from "express";

export interface AuthenticatedRequest extends Request {
  user?: admin.auth.DecodedIdToken;
}

export const requiredAuth = async (
  request: AuthenticatedRequest,
  response: Response,
  next: NextFunction,
) => {
  try {
    const authHeader =
      (request.headers.authorization as string | undefined) ??
      request.get("authorization");

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return response
        .status(401)
        .json({ success: false, error: "Unauthorized - Missing token" });
    }

    const idToken = authHeader.split(" ")[1];

    const decodedToken = await admin.auth().verifyIdToken(idToken);

    request.user = decodedToken;

    return next();
  } catch (e) {
    console.error("Error verifying Firebase token:", e);
    return response
      .status(401)
      .json({ success: false, error: "Unauthorized - Invalid token" });
  }
};
