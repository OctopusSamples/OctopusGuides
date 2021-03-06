Feature: Create and deploy a release from Jenkins

  Scenario: Log into Jenkins
    Given I set the following aliases:
      | Username     | #j_username                                                  |
      | Password     | body > div > div > form > div:nth-child(2) > input           |
      | Sign In      | body > div > div > form > div.submit.formRow > input         |
      | Profile Name | #header > div.login > span > a.model-link.inside.inverse > b |
    And I open the shared browser "FirefoxNoImplicitWait"
    And I set the default explicit wait time to "30" seconds
    And I maximize the window
    When I open the URL "http://localhost:8080"
    # It can take some time for Jenkins to start up, so we need to be able to wait here for the login box
    And I populate the "Username" text box with the text "jenkinsadmin" waiting up to "300" seconds
    And I populate the "Password" text box with the text "Password01!"
    And I click the "Sign In" button
    Then I verify the text from the "Profile Name" element matches the regex "jenkinsadmin"
    And I start recording the screen to the directory "C:\screenshots"
    
  Scenario: Modify the existing project
    Given I set the following aliases:
      | Random Quotes Project         | //a[contains(.,'Random Quotes')]                       |
      | Configure                     | //a[contains(.,'Configure')]                           |
      | Add build step                | //button[@type='button'][contains(.,'Add build step')] |
      | Execute Windows batch command | //a[contains(.,'Execute Windows batch command')]       |

    And I display a note with the text "Deploying an Octopus release from Jenkins" for "3" seconds

    And I highlight outside the "Random Quotes Project" link
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}005-random-quotes-link.png"
    And I click the "Random Quotes Project" link

    And I highlight inside the "Configure" link
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}010-create-release-configure.png"
    And I click the "Configure" link

    And I scroll the "Add build step" button into view offset by "-200"
    And I click the "Add build step" button
    And I highlight outside the "Add build step" button
    And I highlight outside the "Execute Windows batch command" option

  @repositoryspecific @octo-built-in-feed
  Scenario: Modify the existing project
    Given I set the following aliases:
      | Add build step                | //button[@type='button'][contains(.,'Add build step')] |
      | Execute Windows batch command | //a[contains(.,'Execute Windows batch command')]       |

    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}015-create-release-build-step.png"
    And I click the "Execute Windows batch command" option
    And I remove the highlight from the "Add build step" button

  @repositoryspecific @artifactory
  Scenario: Modify the existing project
    Given I set the following aliases:
      | Add build step                | //button[@type='button'][contains(.,'Add build step')] |
      | Execute Windows batch command | //a[contains(.,'Execute Windows batch command')]       |

    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}015-create-release-build-step-artifactory.png"
    And I click the "Execute Windows batch command" option
    And I remove the highlight from the "Add build step" button

  @applicationspecific @aspnet
  Scenario: Modify the existing project
    Given I set the following aliases:
      | Command Four           | (//textarea[contains(@name,'command')])[4]                                                                                     |
      | Save                   | //button[@type='button'][contains(.,'Save')]                                                                                   |
      | Create Release Command | Octo.exe create-release --server http://localhost --apiKey %OctopusAPIKey% --project "Random Quotes" --progress --deployto Dev |

    And I scroll the "Command Four" text box into view offset by "-200"
    And I populate the "Command Four" text box with "Create Release Command"
    And I highlight outside the "Command Four" text box
    And I highlight outside the "Save" button
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}020-create-release-command.png"
    And I remove the highlight from the "Command Four" text box

    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}025-create-release-save.png"
    And I click the "Save" button

    And I stop recording the screen

  @applicationspecific @aspnetcore
  Scenario: Modify the existing project
    Given I set the following aliases:
      | Command Five           | (//textarea[contains(@name,'command')])[5]                                                                                     |
      | Save                   | //button[@type='button'][contains(.,'Save')]                                                                                   |
      | Create Release Command | Octo.exe create-release --server http://localhost --apiKey %OctopusAPIKey% --project "Random Quotes" --progress --deployto Dev |

    And I scroll the "Command Five" text box into view offset by "-200"
    And I populate the "Command Five" text box with "Create Release Command"
    And I highlight outside the "Command Five" text box
    And I highlight outside the "Save" button
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}020-create-release-command.png"
    And I remove the highlight from the "Command Five" text box

    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}025-create-release-save.png"
    And I click the "Save" button

    And I stop recording the screen

  @build-now
  Scenario: Run build
    Given I set the following aliases:
      | Build Now      | //a[contains(.,'Build Now')]      |
      | Build Two      | //a[contains(.,'#2')]             |
      | Console Output | //a[contains(.,'Console Output')] |

    And I open the URL "http://localhost:8080/job/Random%20Quotes/"
    And I start recording the screen to the directory "C:\screenshots"

    And I highlight inside the "Build Now" link
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}030-build-and-deploy-now.png"
    And I click the "Build Now" link

    And I highlight inside the "Build Two" link
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}035-build-two.png"
    # Faking a click, because clicking this element fails a lot of the time
    And I mouse over the "Build Two" link
    And I open the URL "http://localhost:8080/job/Random%20Quotes/2/"

    And I highlight inside the "Console Output" link
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}040-build-and-deploy-console.png"
    And I click the "Console Output" link
    And I scroll down "10000" px
    And I sleep for "30" seconds

  @destinationspecific @iis
  Scenario: Get log screenshot
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}045-build-and-deploy-logs.png"

  @destinationspecific @azure-web-app
  Scenario: Get log screenshot
    And I save a screenshot to "c:\screenshots\jenkins\createrelease\#{GuideSpecificScreenshotDir}045-build-and-deploy-logs-azure.png"

  Scenario: display message
    And I display a note with the text "'Deploy Random Quotes release 0.0.2 to Dev: Success' means Octopus deployed the project" for "3" seconds

  Scenario: Shutdown
    Then I fade the screen to "1" "1" "1" over "3000" milliseconds
    And I stop recording the screen
    And I close the browser