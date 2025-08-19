import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editDialog", "editForm", "nameInput", "typeInput", "descriptionInput"]

  openEdit(event) {
    const accountId = event.params.id
    const accountName = event.params.name || ""
    const accountType = event.params.type
    const accountDescription = event.params.description || ""

    // Set form action URL
    this.editFormTarget.action = `/accounts/${accountId}`

    // Set form values
    this.nameInputTarget.value = accountName
    this.typeInputTarget.value = accountType
    this.descriptionInputTarget.value = accountDescription

    // Show dialog
    this.editDialogTarget.classList.remove("hidden")
  }

  closeEdit() {
    this.editDialogTarget.classList.add("hidden")
  }
}