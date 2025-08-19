import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "editDialog", "editForm", "nameInput", "typeInput", "descriptionInput",
    "recordDialog", "recordForm", "amountInput", "recordedAtInput", 
    "recordAccountName", "recordAccountType", "latestSnapshot", "latestAmount", "latestDate",
    "newDialog", "newForm", "newNameInput", "newTypeInput", "newDescriptionInput",
    "errorContainer", "errorList"
  ]

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

  openRecord(event) {
    const accountId = event.params.id
    const accountName = event.params.name
    const accountType = event.params.type
    const latestAmount = event.params.latestAmount
    const latestDate = event.params.latestDate

    // Set form action URL for creating a new snapshot
    this.recordFormTarget.action = `/accounts/${accountId}/account_snapshots`

    // Set account information display
    this.recordAccountNameTarget.textContent = accountName

    // Set account type badge styling
    const typeClasses = {
      'mufg': 'bg-red-100 text-red-700',
      'rakuten_sec': 'bg-purple-100 text-purple-700',
      'daiwa_sec': 'bg-blue-100 text-blue-700',
      'other': 'bg-gray-100 text-gray-700'
    }
    const typeLabels = {
      'mufg': '三菱UFJ',
      'rakuten_sec': '楽天証券',
      'daiwa_sec': '大和証券',
      'other': 'その他'
    }
    
    this.recordAccountTypeTarget.className = `inline-block px-3 py-1 text-xs font-medium rounded-full ml-2 ${typeClasses[accountType] || typeClasses['other']}`
    this.recordAccountTypeTarget.textContent = typeLabels[accountType] || 'その他'

    // Set current datetime
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    const hours = String(now.getHours()).padStart(2, '0')
    const minutes = String(now.getMinutes()).padStart(2, '0')
    this.recordedAtInputTarget.value = `${year}-${month}-${day}T${hours}:${minutes}`

    // Show latest snapshot if available
    if (latestAmount && latestAmount !== '0' && latestDate) {
      this.latestAmountTarget.textContent = `¥${Number(latestAmount).toLocaleString()}`
      this.latestDateTarget.textContent = latestDate
      this.latestSnapshotTarget.classList.remove("hidden")
    } else {
      this.latestSnapshotTarget.classList.add("hidden")
    }

    // Clear amount input
    this.amountInputTarget.value = ""

    // Show dialog
    this.recordDialogTarget.classList.remove("hidden")
  }

  closeRecord() {
    this.recordDialogTarget.classList.add("hidden")
  }

  openNew() {
    // Clear form inputs
    this.newNameInputTarget.value = ""
    this.newTypeInputTarget.value = ""
    this.newDescriptionInputTarget.value = ""
    
    // Hide error messages
    this.errorContainerTarget.classList.add("hidden")
    this.errorListTarget.innerHTML = ""
    
    // Show dialog
    this.newDialogTarget.classList.remove("hidden")
  }

  closeNew() {
    this.newDialogTarget.classList.add("hidden")
  }
}