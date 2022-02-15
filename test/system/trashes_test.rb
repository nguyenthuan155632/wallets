require "application_system_test_case"

class TrashesTest < ApplicationSystemTestCase
  setup do
    @trash = trashes(:one)
  end

  test "visiting the index" do
    visit trashes_url
    assert_selector "h1", text: "Trashes"
  end

  test "creating a Trash" do
    visit trashes_url
    click_on "New Trash"

    click_on "Create Trash"

    assert_text "Trash was successfully created"
    click_on "Back"
  end

  test "updating a Trash" do
    visit trashes_url
    click_on "Edit", match: :first

    click_on "Update Trash"

    assert_text "Trash was successfully updated"
    click_on "Back"
  end

  test "destroying a Trash" do
    visit trashes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trash was successfully destroyed"
  end
end
