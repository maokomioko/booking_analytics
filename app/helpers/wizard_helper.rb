module WizardHelper
  def wizard_step_class(current_step, active_step)
    if current_step == active_step
      'current'
    elsif current_step < active_step
      'active'
    else
      ''
    end
  end
end