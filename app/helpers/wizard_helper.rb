module WizardHelper
  def wizard_step_class(current_step, active_step)
    if current_step == active_step
      'selected'
    elsif current_step < active_step
      'done'
    else
      ''
    end
  end
end