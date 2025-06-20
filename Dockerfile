# ---- Base Stage ----
# Use an official Node.js runtime as a parent image.
# Using a specific version is recommended for production.
FROM oven/bun:slim AS base
WORKDIR /usr/src/app

# ---- Dependencies Stage ----
# Install production and development dependencies.
# 'devDependencies' are needed for the build step.
FROM base AS deps
COPY package*.json ./
RUN bun install

# ---- Build Stage ----
# Build the TypeScript code into JavaScript.
FROM deps AS build
COPY . .
RUN bun run build

# ---- Production Stage ----
# Create a lean production image.
# Copy only the necessary files from the previous stages.
FROM base AS production
ENV NODE_ENV=production
WORKDIR /usr/src/app

# Copy production dependencies from 'deps' stage.
COPY --from=deps /usr/src/app/package*.json ./
RUN bun install --frozen-lockfile

# Copy compiled JavaScript from 'build' stage.
COPY --from=build /usr/src/app/dist ./dist

# Your app binds to port 8080 by default in the code, so expose it.
EXPOSE 8080

# Define the command to run your compiled app.
CMD [ "bun", "run", "dist/index.js" ]