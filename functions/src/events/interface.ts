import { User } from "../user/user";

export interface Event {
  id?: string;
  title?: string;
  description?: string;
  location?: string;
  startTime?: Date | string;
  capacity?: number;
  rsvpCount?: number;
  isRsvped?: boolean;
  attendees?: User[];
}
