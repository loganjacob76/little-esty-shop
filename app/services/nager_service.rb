class NagerService
  def conn
    Faraday.new(
      url: 'https://date.nager.at'
    )
  end

  def get_next_holidays
    resp = conn.get('/Api/v2/NextPublicHolidays/US')
    JSON.parse(resp.body, symbolize_names: true)[0..2]
  end
end