if doc.custom_employee_lifecycle_stage == "Exit":
    # Generate Experience Letter PDF
    pdf_data = frappe.get_print("Employee", doc.name, "Experience Letter")
    file_name = f"Experience_Letter_{doc.employee_name}.pdf"
    file = frappe.get_doc({
        "doctype": "File",
        "file_name": file_name,
        "attached_to_doctype": "Employee",
        "attached_to_name": doc.name,
        "content": pdf_data,
        "is_private": 1
    })
    file.insert(ignore_permissions=True)
    frappe.msgprint(f"Experience Letter generated and attached for {doc.employee_name}")
