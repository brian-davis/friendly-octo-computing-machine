module ButtonHelper
  def html_delete_button(object, message = "Destroy")
    button_to(
      message,
      object,
      {
        method: :delete,
        class: "nav-button nav-action nav-button-to danger",
        data: {
          turbo: false,
          action: "click->confirmable#confirm"
        },
        form: {
          style: "display: inline"
        }
      }
    )
  end
end