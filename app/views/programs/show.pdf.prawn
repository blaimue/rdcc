pdf.text "SIRs for #{@program.name}"

pdf.move_down 30

for sir in @program.sirs.sort_by{|a| a.id}
    write_sir(pdf, sir)
    pdf.move_down 30
end
