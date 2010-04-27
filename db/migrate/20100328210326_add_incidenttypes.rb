class AddIncidenttypes < ActiveRecord::Migration
  def self.up
    Incidenttype.create({:name => "Assault"})
    Incidenttype.create({:name => "Contraband/Weapon"})
    Incidenttype.create({:name => "Customer Injury"})
    Incidenttype.create({:name => "Customer Injury"})
    Incidenttype.create({:name => "Customer Self Injury"})
    Incidenttype.create({:name => "CPS Referral"})
    Incidenttype.create({:name => "De-escalation Rm"})
    Incidenttype.create({:name => "Disclosure"})
    Incidenttype.create({:name => "Employee Injury"})
    Incidenttype.create({:name => "Emergency Hospitalization"})
    Incidenttype.create({:name => "Escort"})
    Incidenttype.create({:name => "Exposure"})
    Incidenttype.create({:name => "False Alarm"})
    Incidenttype.create({:name => "Fire"})
    Incidenttype.create({:name => "Inappropriate Physical Contact"})
    Incidenttype.create({:name => "Intruder"})
    Incidenttype.create({:name => "Medical Customer/Refuse"})
    Incidenttype.create({:name => "Medical Employee Error"})
    Incidenttype.create({:name => "Medication"})
    Incidenttype.create({:name => "Missing Keys"})
    Incidenttype.create({:name => "Other"})
    Incidenttype.create({:name => "Outside medical"})
    Incidenttype.create({:name => "Police Referral"})
    Incidenttype.create({:name => "Property Damage"})
    Incidenttype.create({:name => "Restraint"})
    Incidenttype.create({:name => "Run"})
    Incidenttype.create({:name => "Run Return"})
    Incidenttype.create({:name => "Veh/Damage/Acc"})
  end

  def self.down
    Incidenttype.destroy_all
  end
end
