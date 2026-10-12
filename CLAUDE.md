I'm building a portfolio project and I want to LEARN while building it,
not have you write it for me. I'm targeting software engineer roles and
want to deepen my Python and web design (HTML/CSS) skills.

## The project
A skincare routine app. Users add the products they already own and
their skin concerns. A rules engine builds a safe, ordered AM/PM routine
and a weekly schedule, then sends reminders.

v1 features:
- Product lookup (Open Beauty Facts) with a fallback to paste an
  ingredient list from the box
- Ingredient normalization through an alias table (e.g. "tocopherol" =
  "vitamin E"), with unmatched ingredients logged for review
- Structured profile: skin type, sensitivity, concerns with severity 1-5
- Rules engine:
    1. Hard rules: conflicts between active classes (e.g. retinoid + AHA
       never in the same routine), timing (SPF AM only, retinoids PM),
       step order by product type
    2. Soft scoring: evidence weight x concern severity, adjusted by the
       ingredient's position on the label
    3. Weekly scheduler for alternating nights
- Each routine step shows a short "why" with a citation
- AM/PM reminders in the user's time zone
- "Not medical advice" note

Not in v1: facial scan, buying recommendations, payments.

Data I'll seed by hand first: ~10 active classes, ~10 conflict rules
with citations, ~20 real products with ingredients in label order.

## Stack
- Backend: Python (FastAPI) on Cloudflare Python Workers
- Database: D1
- Frontend: server-rendered Jinja2 templates + htmx, plain CSS,
  minimal JavaScript, served by the same Worker
- Tests: pytest



## Frontend approach
- Mobile first: people check their routine on their phone.
- I'll design wireframes and design tokens myself (colors, type scale,
  spacing, radius as CSS custom properties). Review them and give me
  feedback on layout, hierarchy, spacing and accessibility.
- For each screen, I'll first build static HTML/CSS with fake data, then
  turn it into a Jinja2 template, then wire it to a route.
- Use htmx only where a full page reload feels clunky (adding a product,
  toggling a reminder). Explain each htmx attribute you suggest.
- Use semantic HTML (e.g. <details> for each step's "why").
- Never rely on color alone for conflict warnings; check contrast and
  focus states.

## Build order
Build one feature end to end (data -> engine -> route -> template ->
styling) before starting the next, so there's always something working:
1. Project setup and seed data
2. Rules engine with tests (no UI yet)
3. My Shelf: add and list products
4. Profile and concerns (onboarding)
5. Routine screen (AM/PM + "why")
6. Weekly schedule
7. Product lookup and paste fallback
8. Reminders
9. Deploy, CI, README

## How I want you to work with me
- Start with a plan: phases, data model, and folder structure. Wait for
  my approval before writing anything.
- Go in small steps, one feature at a time.
- Keep the rules engine as plain Python functions separate from the API,
  so it's easy to test.
- For core logic (normalizer, rules engine, scoring, scheduler, API
  routes, data access) and all HTML/CSS/templates: do NOT write the full
  solution. Explain the idea with a tiny example first, then give me a
  skeleton with comments or blanks. I'll write the code.
- Review my code by naming each fix and why, one thing at a time, with a
  short rule to remember. Point me to the error message's type and line
  before giving the answer.
- You CAN write boilerplate and config for me (wrangler config, project
  setup, AWS/IAM setup, CI, seed-data loading scripts, base template
  setup), but explain what each part does.
- Have me write tests for each engine rule before I implement it
  (e.g. "retinoid + glycolic acid never land in the same PM routine").
- If I'm stuck after two hints, show the answer and explain it.
- Never commit or deploy without asking me.