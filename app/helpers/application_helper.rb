# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def unconstrained_text_area(f, field)
     f.text_area field, :rows => nil, :cols => nil
  end
  
  def has_access?(role, level)
    user = User.find(session[:user_id])
    case role
      when HR:
        return user.hr_role >= level
      when PROGRAM:
        return user.program_role >= level
      when WORKORDER:
        return user.workorder_role >= level
    end
    return false
  end
  
  def formatted_date_field(f, obj, field)
    f.text_field field, :value => obj[field]
  end

  def set_focus_to_id(id)
    javascript_tag("$('#{id}').focus()");
  end
  
  def button(object_type, name)
    '<button type="submit" value="Update" name="commit" id="' + object_type + '_submit">' + name + '</button>'
  end

  def paginate(page_number, page_count, total_count, path)
    if total_count < PAGE_SIZE
      return ""
    end
    
    prev_page = page_number-1
    next_page = page_number + 1
    
    prev_link = link_to_unless(prev_page < 0, h("<<"), send(path, :page_number => prev_page))
    status = "&nbsp;Showing #{page_number*PAGE_SIZE+1} - #{[page_number*PAGE_SIZE+page_count, total_count].min} of #{total_count}&nbsp;"
    next_link = link_to_unless (next_page*PAGE_SIZE>total_count, h(">>"), send(path, :page_number => next_page))
    all = link_to("Show all", send(path, :page_number => 'all'))
    
    return prev_link + status + next_link + "&nbsp;&nbsp;&nbsp;" + all
  end

  def write_sir(pdf, sir)
    id = sprintf("%04d", sir.id)
    pdf.text "ID: #{ id }"
    
    pdf.text "Program: #{ sir.program.name }" unless sir.program.nil? or sir.program.name.nil? or sir.program.name.empty?

    pdf.text "Location: #{ sir.location.name }" unless sir.location.nil? or sir.location.name.nil? or sir.location.name.empty?

    pdf.text "Datetime: #{ sir.incident_datetime }" unless sir.incident_datetime.nil?

    pdf.text "Customers: #{sir.customers.collect{|x| x.full_name}.to_sentence}" unless sir.customers.nil? or sir.customers.empty?

    pdf.text "Staff: #{sir.users.collect{|x| x.full_name}.to_sentence}" unless sir.users.nil? or sir.users.nil? or sir.users.empty?

    pdf.text "Incidents: #{ sir.incidenttypes.collect{|x| x.name}.to_sentence }" unless sir.incidenttypes.nil? or sir.incidenttypes.empty?

    pdf.text "Interventions: #{ sir.interventions.collect{|x| x.name}.to_sentence }" unless sir.interventions.nil? or sir.interventions.empty?

    pdf.text "Antecedent: #{ sir.antecedent }" unless sir.antecedent.nil? or sir.antecedent.empty?

    pdf.text "Description: #{ sir.description }" unless sir.description.nil? or sir.description.empty?

    pdf.text "Unsafe behavior: #{ sir.unsafe_behavior }" unless sir.unsafe_behavior.nil? or sir.unsafe_behavior.empty?

    pdf.text "Lsi resolution: #{ sir.lsi_resolution }" unless sir.lsi_resolution.nil? or sir.lsi_resolution.empty?

    pdf.text "Der time in: #{ sir.der_time_in }" unless sir.der_time_in.nil?

    pdf.text "Der time door: #{ sir.der_time_door }" unless sir.der_time_door.nil?

    pdf.text "Der time out: #{ sir.der_time_out }" unless sir.der_time_out.nil?

    pdf.text "Observation report completed: #{ sir.observation_report_completed }" unless sir.der_time_in.nil?

    pdf.text "Injury description: #{ sir.injury_description }" unless sir.injury_description.nil? or sir.injury_description.empty?

    pdf.text "Injury firstaid: #{ sir.injury_firstaid }" unless sir.injury_firstaid.nil? or sir.injury_firstaid.empty?

    pdf.text "Injury followup: #{ sir.injury_followup }" unless sir.injury_followup.nil? or sir.injury_followup.empty?

    pdf.text "Medication description: #{ sir.medication_description }" unless sir.medication_description.nil? or sir.medication_description.empty?

    pdf.text "Medication list: #{ sir.medication_list }" unless sir.medication_list.nil? or sir.medication_list.empty?

    pdf.text "Medication results: #{ sir.medication_results }" unless sir.medication_results.nil? or sir.medication_results.empty?

    pdf.text "Medication prevention: #{ sir.medication_prevention }" unless sir.medication_prevention.nil? or sir.medication_prevention.empty?

    pdf.text "Police report number: #{ sir.police_report_number }" unless sir.police_report_number.nil? or sir.police_report_number.empty?

    pdf.text "Police dispatcher name: #{ sir.police_dispatcher_name }" unless sir.police_dispatcher_name.nil? or sir.police_dispatcher_name.empty?

    pdf.text "Police officer name: #{ sir.police_officer_name }" unless sir.police_officer_name.nil? or sir.police_officer_name.empty?

    pdf.text "Police description: #{ sir.police_description }" unless sir.police_description.nil? or sir.police_description.empty?

    pdf.text "Signatures:" unless sir.signatures.nil? or sir.signatures.empty?

    for signature in sir.signatures
        pdf.text "Signed by #{signature.user.full_name} on #{signature.created_at}" unless signature.nil? or signature.user.nil?
    end
  end
end
