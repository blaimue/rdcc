pdf.text "SIRs for #{@customer.full_name}"

pdf.move_down 30

for sir in @customer.sirs.sort{|a,b| a.incident_datetime <=> b.incident_datetime}
    write_sir(pdf, sir)
    pdf.move_down 30
end
