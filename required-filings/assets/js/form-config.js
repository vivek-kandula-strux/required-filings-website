/* =============================================================
   form-config.js
   The ONLY file you need to edit after initial setup.
   Holds the Pabbly webhook URL and message/behaviour toggles.
   ============================================================= */

const FORM_CONFIG = {
  // -------- 1. Paste your Pabbly webhook URL between the quotes --------
  // To get it: Pabbly Connect -> Create Workflow -> Trigger = Webhook ->
  // copy the "Webhook URL" shown in step 1 of the trigger.
  webhookURL: "https://connect.pabbly.com/webhook-listener/webhook/IjU3NjAwNTY5MDYzNzA0M2Qi_pc/IjU3NjcwNTY5MDYzNTA0MzM1MjZhNTUzMDUxMzQi_pc",

  // -------- 2. Message shown below the form on success --------
  successMessage: "Got it! We will be in touch shortly.",

  // -------- 3. Message shown below the form on failure --------
  errorMessage: "Something went wrong. Please try again.",

  // -------- 4. Clear all fields after a successful submission? --------
  // true  = reset the form (typical lead-capture behaviour)
  // false = leave the user's values in place
  clearFormOnSuccess: true,

  // -------- 5. Disable the submit button + show "Sending..." while in flight? --------
  // true  = button disabled + label changes to "Sending..." until response
  // false = button stays as-is during submission
  showLoadingState: true
};
