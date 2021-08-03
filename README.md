# BigHistory
Use Big Objects to audit all your fields! This package includes the An Apex Action for Flow and Lightning Component for your pages

[<img src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">](https://githubsfdeploy.herokuapp.com/?owner=dannysummerlin&repo=BigHistory&ref=main)

# Use
## Flow Action
Using a Record-Triggered Flow you can take advantage of the new $Record and $Record__Prior variables (with a caveat, see Known Issues) to automatically capture all updated values
![Record Triggered Flow](https://i.imgur.com/u5VrJYk.png)
![copy Record__prior](https://i.imgur.com/USLm2QW.png)
![Add BigHistory Action](https://i.imgur.com/oTrOX1I.png)
![Simple Flow](https://i.imgur.com/2yk7F9l.png)

## Lightning Component
You can then add the BigHistoryList Lightning Component to Record Pages to see the history.

![Lightning Component](https://i.imgur.com/V54os52.png)

If there are sensitive fields you do not want listed in the field history you can use a comma-separated list of field API names in the Exclusion List field.

# Known Issues/Caveats
* Security - be aware of BigObject security, which is everything for everyone
* Record__Prior - must be assigned to a Flow variable, for some reason
* Merge handling - history will not be transfered when records are merged
