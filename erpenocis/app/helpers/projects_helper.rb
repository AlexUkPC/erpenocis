module ProjectsHelper
  def profit(id, val)
    sprintf('%.2f', val - Invoice.where(project_id: id).sum(:invoice_value_for_project_without_vat))
  end
  def profit_proc(id, val)
    sum_invoices = Invoice.where(project_id: id).sum(:invoice_value_for_project_without_vat)
    sprintf('%.2f', (val - sum_invoices) * 100 / val )
  end
  def expenses_amount(id, val)
    sprintf('%.2f', Invoice.where(project_id: id).sum(:invoice_value_for_project_without_vat) )
  end
end
