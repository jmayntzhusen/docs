---
versionFrom: 7.0.0
uid: cloud-databases 
---

# Working with databases

>[!NOTE]
>The databases on your Umbraco Cloud environments are specific to their environment. This means that no matter what you have configured in the `connectionstring` in your `web.config` file, we overwrite the connectionstring to use the SQL Azure Server we provide.


When working with Umbraco Cloud, the way you work with databases might differ from what you're used to. One important aspect of Umbraco Cloud is that you always work isolated to avoid interfering with colleagues or a running website. This includes the database as well.

So when you clone a site locally, Umbraco Cloud automatically creates a local database and populates it with data from your website running on the Cloud. If you don't specify anything before starting up your site locally, it'll be a SQL CE database that lives in the `/App_Data` folder. If you wish to use a local SQL Server instead, you can update the connection string in the web.config, but it's important that you do so before your site start up the first time.

## LocalDB
By default when Umbraco Cloud restores a local database it will be an Umbraco.sdf file in `/App_Data` folder. However if LocalDB is installed and configured, the restore will create an Umbraco.mdf file. To use LocalDB ensure `applicationHost.config` is configured with `loadUserProfile="true"` and `setProfileEnvironment="true"`: https://blogs.msdn.microsoft.com/sqlexpress/2011/12/08/using-localdb-with-full-iis-part-1-user-profile/

```xml
<add name="ASP.NET v4.0" autoStart="true" managedRuntimeVersion="v4.0" managedPipelineMode="Integrated">
   <processModel identityType="ApplicationPoolIdentity" loadUserProfile="true" setProfileEnvironment="true" />
</add>
```

Usually `applicationHost.config` is located in this folder for IIS:
`C:\Windows\System32\inetsrv\config`

and in one of these folders for IIS Express:

`C:\Users\<user>\Documents\IISExpress\config\`

If you're using Visual Studio 2015+ check this path:
`$(solutionDir)\.vs\config\applicationhost.config`

In Visual Studio 2015+ you can also configure which `applicationhost.config` file is used by altering the `<UseGlobalApplicationHostFile>true|false</UseGlobalApplicationHostFile>` setting in the project file (eg: MyProject.csproj). (source: MSDN forum)

## Using Custom Tables with Umbraco Cloud
Umbraco Cloud will ensure that your Umbraco related data is always up to date, but it won't know anything about data in custom tables unless told. Nothing new here, it's basically just like any other host when it comes to non-Umbraco data.

The good news is that you have full access to the SQL Azure databases running on Umbraco Cloud and you can create custom tables just like you'd expect on any other hosting provider. The easiest way to do this is to connect using SQL Management Studio.

A recommended way of making sure your custom tables are present, is to use Migrations to ensure that the tables will be created or altered when starting your site. Migrations will ensure that if you are adding environments to your Umbraco Cloud site, then the tables in the newly created databases will automatically be created for you. Check [this blog post](https://cultiv.nl/blog/using-umbraco-migrations-to-deploy-changes/) for a full walkthrough of how to create and use Migrations.

## Connecting to SQL Azure on Umbraco Cloud Using SQL Management Studio
For security, your database on Umbraco Cloud is running behind a firewall so in order to connect to the database, you'll need to open the firewall for the relevant IPs. This can be a single IP, a list of IPs or even an IP range. It's done from the Connection Details page on your project. Click the "Settings" menu in the upper right corner of your project and select "Connection Details". If you don't see the menu item, it's due to permissions and you'll need to contact the administrator of your project.

### Opening the firewall
The easiest way to open the firewall for your IP address is to click the "Add Now" link. It'll automatically add your current IP address and save the settings. It might take up to five minutes for the firewall to be open for your IP.

If you need to open for specific IP addresses, click the "Add New IP Address" button.

## Setting up SQL Management Studio
Once the firewall is open, it's time to fire up SQL Management Studio and connect to the database. Be aware that a database exist for each environment you have on Umbraco Cloud and any changes you make to custom tables needs to be done for each of them.

To connect, choose "Connect Database Engine" and copy the values from the Connection Details page on Umbraco Cloud where you'll find handy "copy" short-cut buttons to the right of each value. In the "Connect to Server" dialog in SQL Management Studio, choose "SQL Server Authentication" as the authentication type and also remember to click the "Options" button *before you connect* and paste the name of your database in the "Database" input field (otherwise, security settings on Umbraco Cloud will prevent you from connecting). You can see it all in this short gif:

<iframe width="800" height="450" src="https://www.youtube.com/embed/f3YIEHGHZB4?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Connecting to your local Umbraco installation
When cloning down your project to work locally you might want to have a look in your database every now and then. You can connect to your local Umbraco database through, for example, Visual Studio.

In Visual Studio this is done through the Server Explorer. Add a new connection to a SQL server database file. Umbraco's database file can be found in `App_Data`:

![Connecting to Umbraco.mdf in Visual Studio](../images/connect-via-vsstudio.gif)

If this is your first time connecting to a local database this way, you might have to choose a data source when clicking `Add Connection`. Select `Microsoft SQL Server Database File` and hit OK.

Umbraco will create an mdf file (LocalDB) if you have SQL Server installed on your local machine, provided LocalDB is enabled and can be discovered by Deploy. If Deploy can't create an mdf file it will create a SQL CE (sdf) file instead. 

## Backups
It's possible to create a backup of a Cloud database. There are at least two ways of accomplishing this:
- Use SQL Server Management Studio
- Use a PowerShell script

### Backup with SQL Server Management Studio
Follow these steps:
- Log in to Umbraco Cloud, and visit your project page.
- From the "Settings" drop down for the project, select "Connection Details".
- If your IP address is not listed, click "Add now" next to "Your IP address is not on the list". It should then say "Your IP address is on the list".
- Note the server name, login, password, and database listed on this screen for whichever environment you are backing up (e.g., development or live).
- Open SQL Server Management Studio (SSMS).
- Once the "Connect to Server" dialog appears, enter your server name, login, and password (you will also need to be sure the authentication drop down is set to "SQL Server Authentication" rather than "Windows Authentication").
- Click the "Options >>" button.
- In the "Connect to database" field, type the name of your database (this was listed in the Umbraco Cloud connection details page).
- It is very important that you enter the database name. If you do not, the connection will fail.
- Expand "Databases", right click your database (it should be the only one listed), select "Tasks", then select "Export Data-tier Application...".
- Proceed through the dialog, setting the options appropriate to your situation, to save the "bacpac" file. This is your database backup.

### Backup with PowerShell Script
Make sure to change the following:
- Location of the Dac assembly (if needed)
- Your connection string
- Database name
- Backup directory (if needed)

[!include[Db Restore](snippets/dbRestore.md)]

## Moving on
Now that you've connected you can work with the databases on Umbraco Cloud, like you could on any other host. Just remember to let Umbraco Cloud do the work when it comes to the Umbraco related tables (`Umbraco*` and `CMS*` tables).
