# this should be a lib

class CupsTranslator
  def cupsToPrinter(cups_printers)
    cups_printers.map { |k, v| printer(k, v) }
  end

  def toner(values)
    correlate_attributes(values, %w(marker-colors marker-names marker-types marker-messages) +
                         %w(marker-high_levels marker-levels marker-low-levels)).map do |c, n, t, msg, hl, l, ll|
      Toner.new(
        :color      => c,
        :name       => n,
        :type       => t,
        :messages   => msg,
        :high_level => hl,
        :level      => l,
        :low_level  => ll,
      )
    end.compact
  end

  # TODO: return Printer
  def printer(name, values)
    Printer.new(
      :name     => name,
      :info     => values['printer-info'].presence,
      :location => values['printer-location'].presence,
      :model    => values['printer-make-and-model'].presence,
      :toners   => toner(values)
    # "copies"=>"1"
    # "device-uri"=>"dnssd://EPSON%20WF-2540%20Series._ipp._tcp.local./"
    # "finishings"=>"3"
    # "job-hold-until"=>"no-hold"
    # "job-priority"=>"50"
    # "job-sheets"=>"none,none"
    # "number-up"=>"1"
    # "printer-commands"=>"none"
    # "printer-is-accepting-jobs"=>"true"
    # "printer-is-shared"=>"false"
    # "printer-state"=>"3"
    # "printer-state-change-time"=>"1408200052"
    # "printer-state-reasons"=>"none"
    # "printer-type"=>"69242956"
    )
  end

  def correlate_attributes(values, attributes)
    list_attributes(values, attributes.first).zip(*attributes[1..-1].map { |attr| list_attributes(values, attr)})
  end

  def list_attributes(values, name)
    values[name].try(:split, ',') || []
  end

  def self.cupsToPrinter(cups_printers)
    new.cupsToPrinter(cups_printers)
  end
end

