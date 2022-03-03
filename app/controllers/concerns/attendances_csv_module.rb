module AttendancesCsvModule
  extend ActiveSupport::Concern

  def generate_csv(attendances, output_user, output_month)
    fileneme = "#{output_user}の勤怠一覧#{output_month}月分.csv"
    set_csv_request_headers(filename)

    bom = "\uFEFF"
    self.response_body = Enumerator.new do |csv_data|
      csv_data << bom

      header = %i(日付 出社 退社 備考 終了予定時間 業務処理内容 支持者確認㊞)
      csv_data << header.to_csv
      attendances.each do |attendance|
        body = [
          attendance.worked_on,
          attendance.started_at,
          attendance.finished_at,
          attendance.note,
          attendance.expected_end_time,
          attendance.business_processing_details,
          attendance.authentication_state_overwork
        ]
        csv_data << body.to_csv
      end
    end
  end

  def set_csv_request_headers(filename, charset: 'UTF-8')
    self.response.headers['Content-Type'] ||= "text/csv; charset=#{charset}"
    self.response.headers['Content-Disposition'] = "attachment;filename=#{ERB::Util.url_encode(filename)}"
    self.response.headers['Content-Transfer-Encoding'] = 'binary'
  end
end