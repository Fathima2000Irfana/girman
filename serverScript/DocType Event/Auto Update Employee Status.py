# Lifecycle → Status mapping
lifecycle_status_map = {
    "Joining": "Inactive",
    "Probation": "Active",
    "Confirmation": "Active",
    "Exit": "Left",
}

# Apply mapping if stage is set
if doc.custom_employee_lifecycle_stage in lifecycle_status_map:
    doc.status = lifecycle_status_map[doc.custom_employee_lifecycle_stage]