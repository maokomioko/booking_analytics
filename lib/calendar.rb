class Calendar < Struct.new(:view, :date, :month_offset, :callback)
  START_DAY = :monday

  delegate :content_tag, to: :view

  def table
    content_tag :table, class: 'calendar' do
      week_rows
    end
  end

  def week_rows
    weeks.map do |week|
      if week.count { |day| day < date } < 7
        week.map { |day| day_cell(day) }.join.html_safe
      end
    end.join.html_safe
  end

  def day_cell(day)
    content_tag :div, view.capture(day, &callback), date: day, class: 'calendar_item'
  end

  def weeks
    first = date.beginning_of_month.beginning_of_week(START_DAY)
    last = (date + month_offset.month).end_of_month.end_of_week(START_DAY)

    (first..last).to_a.in_groups_of(7)
  end
end
