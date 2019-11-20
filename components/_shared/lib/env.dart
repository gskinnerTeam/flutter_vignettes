
class Env {
	static bool isGalleryActive = false;

	//Utility functions to allow us to nest flutter projects within a parent application, without breaking fonts/image assets.
	//To facilitate this, the package value must be null when used in the primary project, but non-null when used from within the parent app.
	static String getPackage(String value) => isGalleryActive? value : null;
	static String getBundle(String value) => "packages/$value";

/**
 * USAGE
		static String _pkg = "constellations_list";
		static String get pkg => Env.getPackage(_pkg);
		static String get bundle => Env.getBundle(_pkg);

		var style = TextStyle(fontFamily: "Poppins", package: App.pkg);
		var image = Image.asset("images/logo.png", package: App.pkg);
		rootBundle.load('${App.bundle}/assets/glow.png')

 */
}
