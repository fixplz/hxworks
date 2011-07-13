package nape;














class Config {
	
	
	
	
	public static inline var PARTICLE_RADIUS = 1.5;
	
	
	
	
	public static inline var DEFAULT_ELASTIC = 4;
	
	
	public static inline var DEFAULT_ITERATIONS = 4;

	
	
	
	public static inline var OVERLAP = 0.5;
	
	
	
	
	public static inline var MIN_BIAS_COEF = 0.1;
	
	public static inline var MAX_BIAS_COEF = 0.75;
	
	
	public static inline var VEL_BIAS_COEF = 0.0004;
	
	public static inline var BIAS_PEN_COEF = 0.005;
	
	
	public static inline var INT_BIAS_COEF = 0.85;
	
	
	
	
	public static inline var STATIC_VELSQ = 4;
	
	
	
	
	public static inline var ROLLING_FRICTION = 0.025;
	
	
	
	
	public static inline var DEFAULT_CONSTRAINT_BIAS = 0.1;
	
	

	
	public static inline var SLEEP_DELAY  = 20;
	
	
	public static inline var REST_LINEAR  = 0.35;
	public static inline var REST_BIAS_LINEAR = 1.0;
	
	
	public static inline var REST_ANGULAR = 0.35;
	public static inline var REST_BIAS_ANGULAR = 1.0;
	
	
	
	
	public static inline var DEL_BIAS_COEF = MAX_BIAS_COEF - MIN_BIAS_COEF;
	
	public static inline var SUB_BIAS_COEF = 1.0 - INT_BIAS_COEF;
	
	
}
