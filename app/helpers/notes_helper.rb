module NotesHelper
  # new_work_note_path(@work)
  # new_producer_note_path(@producer)
  def notable_new_note_path(notable)
    "/#{notable.class.name.parameterize.pluralize}/#{notable.id}/notes/new"
  end

  def notable_edit_note_path(arr)
    notable, note = arr
    "/#{notable.class.name.parameterize.pluralize}/#{notable.id}/notes/#{note.id}/edit"
  end

  # work_notes_path(@work)
  # producer_notes_path(@producer)
  def notable_notes_path(notable)
    "/#{notable.class.name.parameterize.pluralize}/#{notable.id}/notes"
  end
end