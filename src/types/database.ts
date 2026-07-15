export interface Student {
  id: string;
  name: string;
  pin_code: string | null;
  is_active: boolean;
  created_at: string;
}

export interface AttendanceRecord {
  id: string;
  student_id: string;
  date: string;
  status: 'present' | 'absent' | 'review';
  week_start: string;
  created_at: string;
  updated_at: string;
}

export interface WeeklyExcuse {
  id: string;
  student_id: string;
  week_start: string;
  reason: string | null;
  created_at: string;
}

export type AttendanceStatus = 'present' | 'absent' | 'excused' | 'new_member';
