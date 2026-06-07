import admin from "firebase-admin";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";

if (admin.apps.length === 0) {
  admin.initializeApp();
}

export const db = getFirestore();
export const auth = getAuth();
