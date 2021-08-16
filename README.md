# BigHistory
If you have ever wanted to track more than 20 Field Histories on one sObject, BigHistory is here for you! Use Big Objects to audit all your fields with an Apex Action for Flow and a Lightning Component for your pages

**Version 1.0**: 
[<img src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">](https://githubsfdeploy.herokuapp.com/?owner=dannysummerlin&repo=BigHistory&ref=main)

# Use
## Flow Action
You can use the BigHistory class in an Apex trigger, but the best way to use it is with Record-Triggered Flows.

1. Using a Record-Triggered Flow you can take advantage of the new $Record and $Record__Prior variables (with a caveat, see Known Issues) to automatically capture all updated values <br/> ![Record Triggered Flow](https://i.imgur.com/u5VrJYk.png)
2. Some quirk of Flow doesn't hand $Record__Prior to the Apex as a true sObject, so you need to first create a wrapper "Record" variable of the same type as the $Record itself <br/> ![copy Record__prior](https://i.imgur.com/USLm2QW.png)
3. After that you add the BigHistory action. The "Original Record" input field is marked as optional to accomodate blank data when a record is first created, but it is necessary to catch any changes <br/> ![Add BigHistory Action](https://i.imgur.com/oTrOX1I.png)
4. The simplest Flow will look something like this: <br/> ![Simple Flow](https://i.imgur.com/2yk7F9l.png)

## Lightning Component
You can then add the BigHistoryList Lightning Component to Record Pages to see the history.

![Lightning Component](https://i.imgur.com/V54os52.png)

If there are sensitive fields you do not want listed in the field history you can use a comma-separated list of field API names in the Exclusion List field.

# Known Issues/Caveats
* Record__Prior - must be assigned to a Flow variable. For some reason Flow does not treat Record__Prior as a true sObject when handing off to Apex, so it must be copied into a holder variable
* Security - *be aware* of BigObject security, which is everything for everyone. Big Objects don't have sharing rules, so be sure that anyone who has access to the 
* Merge handling - *be aware* history will not be transfered when records are merged. The entries associated with the original record will still exist, but you will have to know the old record ID and do custom Big Object query in order to see them

# Roadmap/Future
* Add report summary Custom Object with query options built-in
* Look for ways to handle merge data better, may require an ondelete something, trigger or flow
* Add "Include Fields" to Lightning Component for when there are fewer fields you want tracked than you want excluded
