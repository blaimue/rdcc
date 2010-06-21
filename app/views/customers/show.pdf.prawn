pdf.text "SIRs for #{@customer.full_name}"

pdf.move_down 30


for sir in @customer.sirs.sort_by{|a| a.id}
    
    write_sir(pdf, sir)
    pdf.move_down 30
end
