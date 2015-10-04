class Calendar < Struct.new(:view, :date, :month_offset, :callback, :prices)
  START_DAY = :monday

  delegate :content_tag, to: :view

  def output
    [month_div(Date.today), week_rows].join.html_safe
  end

  def week_rows
    weeks.map do |week|
      if week.count { |day| day < date } < 7
        r = []
        r << week.map.with_index { |day, i| check_month_div(day, i) }
        r << (content_tag :tr do
          week.map.with_index { |day, i| day_cell(day, i) }.join.html_safe
        end)
        r.join.html_safe
      end
    end.join.html_safe
  end

  def day_cell(day, i)
    content_tag :td, view.capture(day, &callback), date: day, class: day_classes(day)
  end

  def day_classes(day)
    t_price = get_price(day)
    classes = []

    if !t_price.nil?
      classes << 'selectable' if t_price.price.to_i > 0
      classes << 'active' if t_price.enabled && !t_price.locked
    end

    classes << 'previous' if day < Date.today
    classes << 'today' if day == Date.today
    classes << 'clickable' if day >= Date.today
    classes << 'hidden' if (day - Date.today).to_i.abs >= 90

    classes.empty? ? nil : classes.join(' ')
  end

  def weeks
    first = date.beginning_of_month.beginning_of_week(START_DAY)
    last = (date + month_offset.month).end_of_month.end_of_week(START_DAY)

    (first..last).to_a.in_groups_of(7)
  end

  private

  def get_price(day)
    prices[day].try(:first)
  end

  def check_month_div(day, i)
    unless i == 6
      tomorrow = day + 1
      if day.month < tomorrow.month
        return month_div(tomorrow)
      end
    end
  end

  def month_div(day)
    content_tag :tr, class: 'new_month' do
      content_tag :td, colspan: 7 do
        day.strftime("%B")
      end
    end
  end
end
