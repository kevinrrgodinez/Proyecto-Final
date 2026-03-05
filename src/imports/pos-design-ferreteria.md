Design a modern, professional Point of Sale (POS) system interface for a hardware store (Ferretería). The system is for a single branch and will be used mainly by cashiers.

Style:

Clean, modern, minimal

Professional but friendly

Optimized for speed and usability in a physical store environment

Light theme with industrial colors

Primary color: Dark blue (#1E3A5F)

Accent color: Orange (#F59E0B)

Neutral grays for backgrounds

Large readable typography

Clear visual hierarchy

Rounded corners (8px)

Subtle shadows

Dashboard-style layout

Create the following screens:

LOGIN SCREEN

Logo at top (Ferretería Central)

Email input

Password input

Login button (primary color)

Clean centered card layout

Simple background

MAIN POS SCREEN (Desktop layout, 1440px width)

Layout:

Top navigation bar with:

Logo (left)

Store name

Logged user name + role (Cashier/Admin)

Current date and time

Logout button

Two main columns:

LEFT SIDE (70% width) – Current Sale

Table showing:

Product name

Unit price

Quantity with + and - buttons

Subtotal

Remove icon

Below table:

Subtotal

Discount field

Tax (IVA)

TOTAL (very large and bold)

RIGHT SIDE (30% width) – Product Search & Checkout

Large search bar (Search by name or SKU)

Filters (Category dropdown)

Product result cards:

Product name

Price

Stock indicator (green/yellow/red)

Add button

Checkout section:

Payment method selector (Cash / Card / Transfer)

If Cash selected:

"Amount received" input

"Change" calculated field

Large “Complete Sale” button (orange)

Secondary “Cancel Sale” button

PRODUCTS MANAGEMENT SCREEN

Table layout

Columns:

SKU

Product Name

Category

Brand

Price

Stock

Status

Edit button

Top bar:

Add Product button

Search field

Filters

INVENTORY SCREEN

Table with current stock

Button: “New Stock Movement”

Modal form:

Product

Movement type (IN / OUT / ADJUSTMENT)

Quantity

Reason

Save button

SALES HISTORY SCREEN

Date filters

Table:

Sale ID

Date

Total

Payment method

Seller

View details button

Sale detail modal with items list and totals

UX Requirements:

Buttons large and easy to click

Clear total always visible

High contrast for important actions

Stock indicator colors

Clean spacing

Professional POS aesthetic

Suitable for touchscreen usage

Create reusable components and use auto-layout.