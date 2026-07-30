import assert from "node:assert/strict";

import { repairRequestValidator } from "../validators/repair-request.validator.js";

function expectAllowed(currentStatus, nextStatus) {
  assert.doesNotThrow(() => {
    repairRequestValidator.validateStatusTransition(
      currentStatus,
      nextStatus,
    );
  });
}

function expectRejected(currentStatus, nextStatus) {
  assert.throws(
    () => {
      repairRequestValidator.validateStatusTransition(
        currentStatus,
        nextStatus,
      );
    },
    (error) => {
      assert.equal(error.statusCode, 409);
      assert.equal(error.code, "INVALID_STATUS_TRANSITION");
      return true;
    },
  );
}

expectAllowed("PENDING", "PENDING");
expectAllowed("PENDING", "IN_PROGRESS");

expectAllowed("IN_PROGRESS", "IN_PROGRESS");
expectAllowed("IN_PROGRESS", "COMPLETED");

expectAllowed("COMPLETED", "COMPLETED");

expectRejected("PENDING", "COMPLETED");
expectRejected("IN_PROGRESS", "PENDING");
expectRejected("COMPLETED", "PENDING");
expectRejected("COMPLETED", "IN_PROGRESS");

console.log("PASS: repair request status transition rules");
