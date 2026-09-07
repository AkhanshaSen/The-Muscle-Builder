#!/usr/bin/env python3
"""Generate The Muscle Builder screen-by-screen workflow PDF."""

from datetime import date
from pathlib import Path

from fpdf import FPDF

OUT = Path(__file__).resolve().parent / "The_Muscle_Builder_Workflow.pdf"


class PDF(FPDF):
    def header(self):
        if self.page_no() == 1:
            return
        self.set_x(self.l_margin)
        self.set_font("Helvetica", "I", 9)
        self.set_text_color(120, 120, 120)
        self.cell(
            0,
            8,
            "The Muscle Builder - Screen-by-Screen Workflow",
            align="L",
            new_x="LMARGIN",
            new_y="NEXT",
        )
        self.set_draw_color(200, 200, 200)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.ln(4)
        self.set_x(self.l_margin)

    def footer(self):
        self.set_y(-14)
        self.set_x(self.l_margin)
        self.set_font("Helvetica", "I", 8)
        self.set_text_color(140, 140, 140)
        self.cell(
            0,
            8,
            f"Akhansha Sen  |  Page {self.page_no()}  |  Educational only",
            align="C",
        )

    def h1(self, text: str) -> None:
        self.set_x(self.l_margin)
        self.ln(2)
        self.set_font("Helvetica", "B", 16)
        self.set_text_color(30, 30, 30)
        self.multi_cell(0, 9, text)
        self.ln(2)

    def h2(self, text: str) -> None:
        self.set_x(self.l_margin)
        self.ln(3)
        self.set_font("Helvetica", "B", 12)
        self.set_text_color(180, 70, 40)
        self.multi_cell(0, 7, text)
        self.ln(1)

    def h3(self, text: str) -> None:
        self.set_x(self.l_margin)
        self.ln(2)
        self.set_font("Helvetica", "B", 10)
        self.set_text_color(40, 40, 40)
        self.multi_cell(0, 6, text)

    def body(self, text: str) -> None:
        self.set_x(self.l_margin)
        self.set_font("Helvetica", "", 10)
        self.set_text_color(50, 50, 50)
        self.multi_cell(0, 5.5, text)
        self.ln(1)

    def bullets(self, items):
        self.set_font("Helvetica", "", 10)
        self.set_text_color(50, 50, 50)
        for item in items:
            self.set_x(self.l_margin)
            self.multi_cell(0, 5.5, f"- {item}")
        self.ln(1)

    def flow(self, steps):
        self.set_x(self.l_margin)
        self.set_font("Helvetica", "B", 9)
        self.set_text_color(80, 50, 40)
        self.multi_cell(0, 5.5, " > ".join(steps))
        self.ln(2)


def build() -> None:
    pdf = PDF(format="A4")
    pdf.set_auto_page_break(auto=True, margin=18)
    pdf.set_margins(14, 14, 14)

    # Cover
    pdf.add_page()
    pdf.ln(36)
    pdf.set_font("Helvetica", "B", 26)
    pdf.set_text_color(30, 30, 30)
    pdf.cell(0, 12, "The Muscle Builder", align="C", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Helvetica", "", 14)
    pdf.set_text_color(180, 70, 40)
    pdf.cell(0, 8, "Complete Product Workflow", align="C", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(4)
    pdf.set_font("Helvetica", "", 12)
    pdf.set_text_color(70, 70, 70)
    pdf.cell(0, 7, "Screen-to-screen activity guide", align="C", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(8)
    pdf.set_font("Helvetica", "I", 11)
    pdf.cell(
        0,
        6,
        f"Version 1.0  |  {date.today().isoformat()}",
        align="C",
        new_x="LMARGIN",
        new_y="NEXT",
    )
    pdf.cell(
        0,
        6,
        "Designed & built by Akhansha Sen",
        align="C",
        new_x="LMARGIN",
        new_y="NEXT",
    )
    pdf.ln(16)
    pdf.set_font("Helvetica", "", 10)
    pdf.set_text_color(60, 60, 60)
    pdf.multi_cell(
        0,
        6,
        "This PDF maps every primary screen and nested flow: onboarding, home, "
        "daily check-in, workout plan, live session, nutrition, progress "
        "(history + graphs), profile, and the weekly gym / rest / cheat routine.",
        align="C",
    )

    # Contents
    pdf.add_page()
    pdf.h1("Contents")
    pdf.bullets(
        [
            "1. App overview and navigation map",
            "2. End-to-end daily training workflow",
            "3. Screen-by-screen activity",
            "4. Weekly routine (gym / rest / cheat)",
            "5. Nutrition and Food Pharmer",
            "6. Progress, history, and graphs",
            "7. Data that persists between screens",
            "8. Route quick reference",
        ]
    )

    # 1
    pdf.add_page()
    pdf.h1("1. App overview and navigation map")
    pdf.body(
        "The Muscle Builder is a local-first Flutter companion: mood-aware "
        "workouts, Indian meal suggestions, weekly schedule (gym / rest / cheat), "
        "and progress tracking with charts."
    )
    pdf.h3("Bottom navigation (App Shell)")
    pdf.bullets(
        [
            "Home - greeting, today routine card, plan CTA, quick links",
            "Workout - jump into today's plan or start check-in",
            "Nutrition - pre/post meals, ingredient chips, Food Pharmer pointers",
            "Progress - stats, week strip, analysis charts, histories",
            "Profile - identity, guides, weekly routine editor, settings",
        ]
    )
    pdf.h3("Full-screen nested routes (no bottom bar)")
    pdf.bullets(
        [
            "/onboarding - first-run setup (5 steps)",
            "/checkin - daily check-in (5 steps) then generate plan",
            "/plan/:planId - customize routine and start session",
            "/session/:sessionId - live train / rest / finish loop",
        ]
    )
    pdf.h2("Happy-path navigation")
    pdf.flow(
        [
            "Onboarding",
            "Home",
            "Check-in",
            "Plan",
            "Session",
            "Progress / Nutrition",
        ]
    )

    # 2
    pdf.h1("2. End-to-end daily training workflow")
    pdf.h3("A. First launch")
    pdf.bullets(
        [
            "If onboarding incomplete, app redirects to /onboarding",
            "User enters name, body stats, goals, equipment, diet",
            "On finish, profile is saved and user lands on Home",
        ]
    )
    pdf.h3("B. Typical gym day")
    pdf.bullets(
        [
            "Home: see planned day type; optionally log Gym / Rest / Cheat",
            "Start or re-do Daily check-in (5 steps including pre-meal)",
            "Generate saves WorkoutPlan (exercises + pre/post meals)",
            "Open workout on Plan screen: trim moves, sets, meals, gym time",
            "Start session: Form cues -> log sets -> Rest -> next exercise",
            "Finish: session completed, day auto-marked Gym, calorie dialog",
            "Optional: See meals opens Nutrition on Post-workout tab",
            "Progress refreshes sets, sessions, day history, and graphs",
        ]
    )
    pdf.h3("C. Rest or cheat day")
    pdf.bullets(
        [
            "On Home Today card, log Rest or Cheat",
            "Nutrition and Profile remain available",
            "Progress stores planned vs logged for adherence",
        ]
    )

    # 3
    pdf.add_page()
    pdf.h1("3. Screen-by-screen activity")

    pdf.h2("3.1 Onboarding (/onboarding)")
    pdf.body("Shown only when onboardingComplete is false.")
    pdf.bullets(
        [
            "Step 1 - Name and journey name",
            "Step 2 - Body stats (weight, height, age, gender, activity)",
            "Step 3 - Goals, experience, coach tone",
            "Step 4 - Equipment multi-select",
            "Step 5 - Diet type, cuisine region, allergies, macros toggle",
            "Final CTA Start training saves profile and goes to Home",
        ]
    )

    pdf.h2("3.2 Home (/home)")
    pdf.bullets(
        [
            "Personalized tip from coach tone",
            "This-week workout count and coach chip",
            "Today routine card: planned kind + log Gym / Rest / Cheat",
            "No plan: Start check-in",
            "Has plan: Open workout, Re-do check-in, encouragement",
            "Quick actions: Meals, Progress",
            "Pull-to-refresh for plan and week stats",
        ]
    )
    pdf.flow(["Home", "Check-in or Plan or Nutrition or Progress"])

    pdf.h2("3.3 Workout tab (/workout)")
    pdf.bullets(
        [
            "Shortcut into the same plan / check-in loop as Home",
            "Opens /plan/:id when a plan exists, else /checkin",
        ]
    )

    pdf.h2("3.4 Daily check-in (/checkin) - 5 steps")
    pdf.bullets(
        [
            "1 Mood - tired / stressed / low / energetic / motivated",
            "2 Intensity + gym minutes (20-150) driving exercise count",
            "3 Focus - strength / stamina / hypertrophy / mobility",
            "4 Target muscles - body map, presets, Surprise me",
            "5 Pre-workout meal - diet / allergy / chip filtered",
            "Generate creates plan, invalidates providers, continues to training",
        ]
    )

    pdf.add_page()
    pdf.h2("3.5 Workout plan (/plan/:planId)")
    pdf.bullets(
        [
            "Ordered exercise list (compounds before isolation)",
            "Change gym minutes to resize today's active list",
            "Adjust sets; skip an exercise for today",
            "View / swap pre and post meals; form posture gallery",
            "Calorie snapshot: estimated burn vs meal fuel",
            "Start session creates WorkoutSession and opens Session",
        ]
    )

    pdf.h2("3.6 Live session (/session/:sessionId)")
    pdf.bullets(
        [
            "Form panel - step-by-step cues (timer paused)",
            "Train panel - weight, reps, RPE; tick sets (live Progress)",
            "Rest panel - countdown with skip option",
            "Finish completes session, marks today Gym, shows calorie balance",
            "See meals -> /nutrition?timing=post",
        ]
    )

    pdf.h2("3.7 Nutrition (/nutrition)")
    pdf.bullets(
        [
            "Tabs: Pre-workout / Post-workout",
            "Cuisine chips: North / South / Pan Indian",
            "Macros on/off persisted on profile",
            "I want to eat chips (horizontal): protein, curd, eggs, paneer, "
            "chicken, oats, dates, fruit, spinach, ragi/millet, legumes",
            "Protein focus shortcut",
            "Food Pharmer pointer cards open foodpharmer.health",
            "Meal cards: portion, timing, macros, nutrition notes, recipes",
        ]
    )

    pdf.h2("3.8 Progress (/progress)")
    pdf.bullets(
        [
            "Encouragement + today's calorie balance",
            "Stats: sets today/week, workouts done/this week",
            "Muscles trained from completed sessions",
            "This week's plan strip (7 day kinds)",
            "Routine analysis: adherence %, pie chart, gym-days bar chart",
            "Day history (planned vs logged)",
            "Pre-meal log from check-ins",
            "Session history (muscles, duration, sets, pre meal)",
        ]
    )

    pdf.h2("3.9 Profile (/profile)")
    pdf.bullets(
        [
            "Journey hero with editable names / stats",
            "Yogurt and dahi fuel carousel -> Nutrition",
            "Coach-approved reading (Food Pharmer, ACSM, EatRight, NHS, NIN, IIMR)",
            "Weekly routine editor (Mon-Sun Gym / Rest / Cheat)",
            "Theme, appearance, coach personality",
            "Training and diet settings",
            "Faded signature: Designed & built by Akhansha Sen",
        ]
    )

    # 4
    pdf.add_page()
    pdf.h1("4. Weekly routine (gym / rest / cheat)")
    pdf.body(
        "This calendar is separate from the exercise generator (RoutineEngine)."
    )
    pdf.h3("Define - Profile")
    pdf.bullets(
        [
            "Profile > Settings > Weekly routine",
            "Assign each weekday Gym, Rest, or Cheat",
            "Stored in WeeklyRoutines (JSON weekday map)",
            "Default: Mon/Wed/Fri/Sat Gym, Tue/Thu Rest, Sun Cheat",
        ]
    )
    pdf.h3("Execute - Home")
    pdf.bullets(
        [
            "Today card shows Planned kind from the template",
            "User logs actual kind into DayLogs",
            "Finishing a session auto-logs Gym for today",
        ]
    )
    pdf.h3("Analyze - Progress")
    pdf.bullets(
        [
            "Week strip uses logged actual, else planned",
            "Adherence = logged gym hits / planned gym days",
            "Pie: gym / rest / cheat mix (about 4 weeks)",
            "Bar: logged gym days per week across 4 weeks",
            "Day history lists planned vs logged",
        ]
    )

    # 5
    pdf.h1("5. Nutrition and Food Pharmer")
    pdf.bullets(
        [
            "Meals from assets/data/meals.json including ragi, spinach, dates, fruits",
            "Filters: timing x diet x allergies x region x ingredient tags (OR)",
            "nutritionNotes cite ICMR-NIN / IIMR / USDA-style facts (educational)",
            "Food Pharmer cards deep-link to Better for You criteria pages",
            "Unlock recipe stores meal id on profile",
        ]
    )

    # 6
    pdf.h1("6. Progress, history, and graphs")
    pdf.bullets(
        [
            "Each logged set bumps a tick provider so Progress refreshes live",
            "Completed sessions + set logs drive workout stats",
            "Pre/post meals on plans feed the Pre-meal log",
            "DayLogs + WeeklyRoutines feed strip, history, and fl_chart charts",
        ]
    )

    # 7
    pdf.add_page()
    pdf.h1("7. Data that persists between screens")
    pdf.h3("Drift / SQLite tables")
    pdf.bullets(
        [
            "UserProfiles - identity, diet, theme, chips, unlocked recipes",
            "DailyCheckIns - mood, intensity, muscles, focus",
            "WorkoutPlans - exercises, encouragement, meals, gym minutes",
            "WorkoutSessions / SetLogs - training history",
            "WeeklyRoutines - Mon-Sun template",
            "DayLogs - per-date planned + actual day kind",
        ]
    )
    pdf.h3("Cross-screen effects")
    pdf.bullets(
        [
            "Profile diet / allergies / chips -> Nutrition + check-in meals",
            "Check-in -> Plan -> Session -> Progress + day=Gym",
            "Weekly routine -> Home today + Progress graphs",
            "Session finish -> optional Nutrition post tab",
        ]
    )

    # 8
    pdf.h1("8. Route quick reference")
    pdf.set_font("Helvetica", "B", 9)
    pdf.set_fill_color(240, 240, 240)
    pdf.cell(58, 7, "Route", border=1, fill=True)
    pdf.cell(62, 7, "Screen", border=1, fill=True)
    pdf.cell(56, 7, "Notes", border=1, fill=True, new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Helvetica", "", 8)
    rows = [
        ("/onboarding", "OnboardingScreen", "First run"),
        ("/home", "HomeScreen", "Tab 1"),
        ("/workout", "WorkoutTabScreen", "Tab 2"),
        ("/nutrition", "NutritionScreen", "Tab 3 (+ timing query)"),
        ("/progress", "ProgressScreen", "Tab 4"),
        ("/profile", "ProfileScreen", "Tab 5"),
        ("/checkin", "CheckInScreen", "Nested full screen"),
        ("/plan/:planId", "WorkoutPlanScreen", "Nested full screen"),
        ("/session/:sessionId", "SessionScreen", "Nested full screen"),
    ]
    for route, screen, notes in rows:
        pdf.cell(58, 6, route, border=1)
        pdf.cell(62, 6, screen, border=1)
        pdf.cell(56, 6, notes, border=1, new_x="LMARGIN", new_y="NEXT")

    pdf.ln(10)
    pdf.h2("Master activity flowchart")
    pdf.body(
        "Onboarding > Home (log today) > Check-in (5 steps) > Plan (customize) > "
        "Session (form / train / rest) > Finish (Gym day + calories) > "
        "Progress (history / graphs) and/or Nutrition (post meals). "
        "Use Profile anytime for weekly routine and diet preferences."
    )
    pdf.ln(4)
    pdf.set_font("Helvetica", "I", 9)
    pdf.set_text_color(100, 100, 100)
    pdf.multi_cell(
        0,
        5,
        "Not medical advice. External nutrition links are educational attributions only.",
    )

    pdf.output(str(OUT))
    print(f"Wrote {OUT}")


if __name__ == "__main__":
    build()
