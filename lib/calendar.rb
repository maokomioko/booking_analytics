class Calendar < Struct.new(:view, :date, :month_offset, :callback)
    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        week_rows
      end
    end

    def week_rows
      weeks.map do |week|
        unless week.count { |day| day < Date.today } == 7
          content_tag :tr do
            week.map { |day| day_cell(day) }.join.html_safe
          end
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), date: day, class: [day_classes(day), ('selectable' if Date.today < day)]
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Date.today
      classes << "not-month" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = (date + month_offset.month).end_of_month.end_of_week(START_DAY)

      (first..last).to_a.in_groups_of(7)
    end
end
