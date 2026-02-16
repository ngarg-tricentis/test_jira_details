@qtest @login
Feature: qTest Authentication
  As a qTest user
  I want to authenticate securely
  So that I can access qTest projects and assets

  # Set your base URL(s) via environment or placeholders.
  # Example:
  #   QTEST_BASE_URL=https://<your-tenant>.qtestnet.com
  #   QTEST_SSO_URL=https://<your-idp>/... (if applicable)

  Background:
    Given the qTest application is reachable

  @smoke @happy_path
  Scenario: Login with valid username and password
    Given I am on the qTest login page
    When I enter username "valid.user@example.com"
      And I enter password "ValidPassword123!"
      And I click the "Sign In" button
    Then I should be redirected to the qTest landing page
      And I should see my username "valid.user@example.com" in the header
      And I should see the Projects panel

  @negative
  Scenario Outline: Login fails with invalid credentials
    Given I am on the qTest login page
    When I enter username "<username>"
      And I enter password "<password>"
      And I click the "Sign In" button
    Then I should remain on the qTest login page
      And I should see an authentication error message "<errorMessage>"

    Examples:
      | username                   | password           | errorMessage                               |
      | invalid.user@example.com   | ValidPassword123!  | Invalid username or password               |
      | valid.user@example.com     | WrongPassword!     | Invalid username or password               |
      |                            | ValidPassword123!  | Username is required                       |
      | valid.user@example.com     |                    | Password is required                       |

  @security @negative
  Scenario: Login blocked for locked/suspended user
    Given I am on the qTest login page
    When I enter username "locked.user@example.com"
      And I enter password "AnyPassword1!"
      And I click the "Sign In" button
    Then I should remain on the qTest login page
      And I should see an authentication error message "Your account is locked or suspended. Contact your administrator."

  @sso @happy_path
  Scenario: Login with Single Sign-On (SSO)
    Given I am on the qTest login page
    When I click "Sign in with SSO"
      And I am redirected to my Identity Provider
      And I authenticate successfully via the Identity Provider
    Then I should be redirected to the qTest landing page
      And I should see the Projects panel

  @sso @negative
  Scenario: SSO fails due to authorization error
    Given I am on the qTest login page
    When I click "Sign in with SSO"
      And I am redirected to my Identity Provider
      And I cancel or fail authentication
    Then I should be returned to the qTest login page
      And I should see an authentication error message "Single sign-on failed"

  @usability
  Scenario: Password is masked by default and can be toggled
    Given I am on the qTest login page
    When I enter password "SamplePassword1!"
    Then the password field should mask the characters
    When I toggle "Show password"
    Then the password field should reveal the characters
    When I toggle "Show password" off
    Then the password field should mask the characters again

  @validation
  Scenario: Remember me option persists session according to policy
    Given I am on the qTest login page
    When I enter username "valid.user@example.com"
      And I enter password "ValidPassword123!"
      And I check "Remember me"
      And I click the "Sign In" button
    Then I should be redirected to the qTest landing page
    When I close and reopen the browser within the allowed session window
      And I navigate to the qTest landing page
    Then I should remain signed in (unless org policy requires re-authentication)

  @security @rate_limiting
  Scenario: Rate limiting after repeated failed attempts
    Given I am on the qTest login page
    When I attempt to sign in with an invalid password more than the allowed number of times
    Then I should see a message indicating temporary lockout or CAPTCHA challenge

  @accessibility
  Scenario: Login form is accessible
    Given I am on the qTest login page
    Then all inputs have associated labels
      And the "Sign In" button is reachable via keyboard
      And the page has a programmatic title
      And error messages are announced to assistive technologies

