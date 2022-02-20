module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  # 不正な値があるか確認する
  def edit_attendances_invalid?
    attendances = true
    edit_attendances_params.each do |id, item|
      if item[:edit_started_at].blank? && item[:edit_finished_at].blank?
        next
      elsif item[:edit_started_at].blank? || item[:edit_finished_at].blank?
        attendances = false
        break
      elsif item[:edit_started_at] > item[:edit_finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end

  def attendances_invalid?
    attendances = true
    edit_attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end

  def calc_overwork_time(expected_end_time, designated_work_end_time, next_day)
    if next_day == "1"
      overtime_hour = format("%.2f", (((expected_end_time - designated_work_end_time) / 60) / 60.0))
    else
      overtime_hour = format("%.2f", (((expected_end_time - designated_work_end_time) / 60) / 60.0))
    end
  end

  def all_user_missing(missing_user_count, days)
    if missing_user_count == days
      flash[:danger] = "所属長を選択してください"
    end
  end
end