if [ ! -n "$WERCKER_HIPCHAT_NOTIFY_TOKEN" ]; then
  error 'Please specify token property'
  exit 1
fi

if [ ! -n "$WERCKER_HIPCHAT_NOTIFY_ROOM_ID" ]; then
  error 'Please specify room_id property'
  exit 1
fi

if [ ! -n "$WERCKER_HIPCHAT_NOTIFY_FROM_NAME" ]; then
  error 'Please specify from_name property'
  exit 1
fi


if [ ! -n "$WERCKER_HIPCHAT_NOTIFY_FAILED_MESSAGE" ]; then
	if [ ! -n "$DEPLOY" ]; then
		export WERCKER_HIPCHAT_NOTIFY_FAILED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: deploy to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY failed."
	else
		export WERCKER_HIPCHAT_NOTIFY_FAILED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: build of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY failed."
	fi
fi

if [ ! -n "$WERCKER_HIPCHAT_NOTIFY_PASSED_MESSAGE" ]; then
	if [ ! -n "$DEPLOY" ]; then
		export WERCKER_HIPCHAT_NOTIFY_PASSED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: deploy to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY passed."
	else
		export WERCKER_HIPCHAT_NOTIFY_PASSED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: build of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY passed."
	fi
fi

if [ "$WERCKER_RESULT" == "passed" ]; then
	export WERCKER_HIPCHAT_NOTIFY_MESSAGE="$WERCKER_HIPCHAT_PASSED_MESSAGE"
else
	export WERCKER_HIPCHAT_NOTIFY_MESSAGE="$WERCKER_HIPCHAT_FAILED_MESSAGE"
fi


if [ ! "$WERCKER_HIPCHAT_NOTIFY_ON" == "failed" ]; then
	if [ "$WERCKER_RESULT" == "passed" ]; then
		echo "Skipping.."
		return 0
	fi
fi

echo "run python"
python "$WERCKER_STEP_ROOT/main.py" $WERCKER_HIPCHAT_NOTIFY_TOKEN $WERCKER_HIPCHAT_NOTIFY_ROOM_ID $WERCKER_HIPCHAT_NOTIFY_FROM_NAME "$WERCKER_HIPCHAT_NOTIFY_MESSAGE"
