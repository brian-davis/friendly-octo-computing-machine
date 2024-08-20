module NotesHelper
  def human_updated_at(object)
    t = object.updated_at
    t.strftime("%A, %B #{t.day.ordinalize}, %Y @ %l:%M %p")
  end
end