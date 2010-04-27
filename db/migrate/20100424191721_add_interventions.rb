class AddInterventions < ActiveRecord::Migration
  def self.up
    Intervention.create({:name => "Managing the environment"})
    Intervention.create({:name => "Prompting"})
    Intervention.create({:name => "Caring gesture"})
    Intervention.create({:name => "Hurdle help"})
    Intervention.create({:name => "Redirection"})
    Intervention.create({:name => "Proximity"})
    Intervention.create({:name => "Directive statements"})
    Intervention.create({:name => "Time away"})
    Intervention.create({:name => "Emotional First Aid"})
    Intervention.create({:name => "Crisis co-regulation"})
    Intervention.create({:name => "Active Listening"})
    Intervention.create({:name => "Space and time"})
    Intervention.create({:name => "Understanding statements"})
    Intervention.create({:name => "Stating positive outcomes"})
    Intervention.create({:name => "Collaborative problem solving"})
    Intervention.create({:name => "Mindfulness skills"})
    Intervention.create({:name => "Emotion regulation skills"})
    Intervention.create({:name => "Distress tolerance skills"})
    Intervention.create({:name => "Interpersonal Effectiveness skills"})
  end

  def self.down
    Intervention.destroy_all
  end
end
